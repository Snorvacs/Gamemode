local runtime, exports = ...

local RankingTree = runtime.require("./rank").RankingTree

local Org = runtime.oop.create("Org")
exports["Org"] = Org

function Org:__ctor()
    -- Defaults
    self.color = Color(128, 128, 128)
    self.name = "Unnamed Organisation"
    self.rankingTree = RankingTree:__new()
end