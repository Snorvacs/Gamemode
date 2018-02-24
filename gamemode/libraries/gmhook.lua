GM.Hooks = {}

local function CallHooks( hooks, ... )
	for _, func in next, hooks do
		local returns = { func( ... ) }
		if returns[ 1 ] then
			return unpack( returns )
		end
	end
end

function GM:AddHook( event, name, func )
	if !self.Hooks[ event ] then
		self.Hooks[ event ] = {}
		GM[ event ] = function( ... )
			return CallHooks( self.Hooks[ event ], ... )
		end
	end

	self.Hooks[ event ][ name ] = func
end