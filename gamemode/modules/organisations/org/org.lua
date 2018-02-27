local runtime, exports = ...

local Rank = runtime.require("./rank").Rank

local Org = runtime.oop.create("Org")
exports["Org"] = Org

function Org:__ctor()
    -- Defaults
    self.color = Color(128, 128, 128)
    self.name = "Unnamed Organisation"

    self.ranks = {}
end

function Org:addRank(position)
    self.ranks[position] = Rank:__new()
end

function Org:removeRank(position)
    self.ranks[position] = nil
end

function Org:getRanks()
    return self.ranks
end

