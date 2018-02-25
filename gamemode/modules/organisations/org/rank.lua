local runtime, exports = ...

local Rank = runtime.oop.create("Rank")
exports["Rank"] = Rank

function Rank:__ctor()
end

local RankingTree = runtime.oop.create("RankingTree")
exports["RankingTree"] = RankingTree

function RankingTree:__ctor()
end