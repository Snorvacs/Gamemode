local runtime, exports = ...

local Org = runtime.require("./org").Org

local Organisations = runtime.oop.create("Organisations")
exports["organisations"] = Organisations

function Organisations:__ctor()
    self.orgs = {}
end

function Organisations:addOrg(id, org)
    self.orgs[id] = org
end

function Organisations:removeOrg(id)
    self.orgs[id] = nil
end

function Organisations:setupHooks()
end