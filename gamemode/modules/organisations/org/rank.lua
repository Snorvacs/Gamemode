local runtime, exports = ...

local Rank = runtime.oop.create("Rank")
exports["Rank"] = Rank

function Rank:__ctor()
end

function Rank:getParent()

function Rank:getChildren()
end

function Rank:addChild(childId)

local RankingTree = runtime.oop.create("RankingTree")
exports["RankingTree"] = RankingTree

-- What should this contain?
-- Default Rank
-- Trees which connect to default rank and then
-- branch out into many other ranks

function RankingTree:__ctor()
    self.ranks = {}
    self.root = nil
end

-- Add a rank and connect the specified parent to it.
-- If parent is nil, check if there is a root on the tree. If there is a root then this rank is invalid and we cannot add it.
-- There's no way we can create a cyclic dependency in this function.
function RankingTree:addRank(rankId, parentId)
    assert(rankId, "Attempted to create a rank with an invalid Id")
    assert(self.ranks[rankId], "A rank with this Id already exists inside of the tree")
    assert(not parentId and self.root, "A root node already already exists on this tree")
    assert(isstring(rankId), "Ranks can only be created with a string as its identifier")
    assert(isstring(parentId), "Ranks can only be created with a string as its identifier")

    if not parentId then
        self.root = Rank:__new()
    end

    local rank = not parentId and self.root or Rank:__new()

    if parentId then
        rank:setParent(parentId)
        self.ranks[parentId]:addChild(rankId)
    end

    self.ranks[rankId] = rank
end

function RankingTree:insertRank(rankId, parentId)
    local newTree = 
end

-- Remove a rank and all of its children
function RankingTree:removeRank()
end

-- We want ranks to be stored in a tree, not a graph.
-- Otherwise it will likely be confusing for those that run an organisation
function RankingTree:hasCyclicDependency(newTree)
end