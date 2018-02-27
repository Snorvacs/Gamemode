-- LuaExtended-compatible Lua Runtime Helper Library

assert(jit and jit.version == "LuaJIT 2.0.4","This runtime library is built for LuaJIT 2.0.4!")

local runtime = {}
runtime.version = 20170509

local debug = debug
runtime.internal = {}

function runtime.internal.parseCallInfo(callInfo)
	local isFile = string.EndsWith(callInfo.source, ".lua")

	if isFile then
		local stack = {}
		for i in callInfo.source:gsub("\\", "/"):gmatch("[^/]+") do
			stack[#stack + 1] = i
		end
		return true, table.concat(stack, "/", 1, #stack - 1):sub(2, -1)
	else
		return isFile, callInfo.source:sub(2, -1)
	end
end

function runtime.internal.parseFilePath(path)
	local isRelative, fileName, normalisedPath = false, "", ""

	isRelative = path:sub(1,1) == "."

	local stack = {}
	for i in path:gsub("\\", "/"):gmatch("[^/]+") do
		if i == "." then
		elseif i == ".." then
			stack[#stack] = nil
		else
			stack[#stack + 1] = i
		end
	end

	return isRelative, stack[#stack], table.concat(stack, "/")
end

function runtime.internal.require(path)
	local fileData = file.Read(path, "GAME")
	if not fileData then return false, false end
	local fn = CompileString(fileData, path, false)
	if not isfunction(fn) then return false, fn end

	local exports = {}
	local success, err = xpcall(fn,
	function(err)
		print("Error loading module " .. path)
		print(debug.traceback(err))
		return err
	end, runtime, exports)

	if not success then
		return false, err
	else
		return true, false, exports
	end
end

-- Have a similar behaviour to requiring in ES 6
function runtime.require(path)
	local isFile, src = runtime.internal.parseCallInfo(debug.getinfo(2))
	local isRelative, fileName, normalisedPath = runtime.internal.parseFilePath(path)

	if isRelative and isFile then
		local success, err, exports = false, ""
		if src then
			success, err, exports = runtime.internal.require(src .. "/" .. normalisedPath)
		else
			success, err, exports = runtime.internal.require(normalisedPath)
		end

		if success then
			return exports
		elseif not success and err then
			error(err)
		elseif not success then
			error("File not found")
		end
	end
end

runtime.oop = {}

runtime.oop.ptr = 0

function runtime.oop.uuid()
	runtime.oop.ptr = runtime.oop.ptr + 1

	return runtime.oop.ptr
end

function runtime.oop.superBind(origSelf,inputSelf,fn)
	return setmetatable({},{
		__call = function(_,self,...)
			if self == inputSelf then
				self = origSelf
			end

			return fn(self,...)
		end,
		__tostring = function(self)
			return string.format("SuperFunction: %p",self)
		end,
	})
end

function runtime.oop.constructFrom(inst,meta,...)
	local instance = setmetatable(inst,meta)

	instance.__uuid = runtime.oop.uuid()

	-- HACK: table:__gc is not supported in LuaJIT 2.0.3
	instance.__gcproxy = newproxy(true)
	instance.__gcproxymeta = {}
	debug.setmetatable(instance.__gcproxy,instance.__gcproxymeta)

	-- HACK: table:__gc is not supported in LuaJIT 2.0.3
	instance.__gcproxymeta.__gc = function() return instance:__gc() end

	if instance.__parent then
		instance.super = {}
		setmetatable(instance.super,{
			__index = function(self,k)
				local v = instance.__parent[k]

				if type(v) == "function" then
					return runtime.oop.superBind(instance,self,v)
				else
					return v
				end
			end,
		})
	end

	instance:__ctor(...)

	return instance
end

function runtime.oop.construct(meta,...)
	return runtime.oop.constructFrom({},meta,...)
end

function runtime.oop.create(name,secure)
	local meta = {}

	meta.__name = name
	meta.__secure = secure and true
	-- meta.__parent = nil

	function meta:__gc()
		-- if not self.__destroyed then
		--	 self.__destroyed = true
		--	 self:__dtor()
		-- end
	end
	function meta:__ctor(...)
		if self.__parent and self.__parent.__ctor then return self.__parent.__ctor(self,...) end
	end
	function meta:__dtor(...)
		if self.__parent and self.__parent.__dtor then return self.__parent.__dtor(self,...) end
	end

	function meta:__tostring()
		return string.format("%s [%d]",self.__name,self.__uuid)
	end

	-- meta.__index = function(self,k)
	--	 if rawget(self,k) ~= nil then return rawget(self,k) end
	--	 if meta[k] ~= nil then return meta[k] end
	--	 if meta.__parent then return meta.__parent[k] end
	-- end

	meta.__index = meta

	function meta:__new(...)
		return runtime.oop.construct(meta,...)
	end

	function meta:__newFrom(src,...)
		return runtime.oop.constructFrom(src,meta,...)
	end

	return meta
end

function runtime.oop.checkCircular(meta,deps)
	if not meta then return end
	deps = deps or {}
	deps[meta] = true
	if deps[meta.__parent] then error("Class "..meta.__name.." has a circular dependency!") end
	runtime.oop.checkCircular(meta.__parent,deps)
end

function runtime.oop.inherits(meta,source)
	if meta == source then return true end
	if meta.__parent == source then return true end

	if meta.__parent then
		if runtime.oop.inherits(meta.__parent,source) then return true end
	end

	return false
end

function runtime.oop.extend(meta,source)
	meta.__parent = source
	if meta.__parent then
		setmetatable(meta,meta.__parent)
	end
	runtime.oop.checkCircular(meta)
end

function runtime.oop.destroy(instance)
	return instance:__dtor()
end

return runtime