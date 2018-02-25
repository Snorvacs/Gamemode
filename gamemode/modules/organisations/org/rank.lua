local runtime, exports = ...

local Rank = runtime.oop.create("Rank")
exports["Rank"] = Rank

function Rank:__ctor()
end

function Rank:getParents()
end

function Rank:addParent()
end

function Rank:getChildren()
end

function Rank:addChild(childId)
end

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
        rank:addParent(parentId)
        self.ranks[parentId]:addChild(rankId)
    end

    self.ranks[rankId] = rank

    return rank
end

function RankingTree:insertRank(rankId, parentId, childIds)
    assert(not self:doesInsertionCreateCycle(parentId, childIds), "Adding rankId to the graph would create a cycle")
    for k, v in pairs(childIds) do
        assert(self.ranks[childId], "An invalid identifier for a child was supplied")
    end
    assert(self.ranks[parentId], "An invalid identifer for the parent was supplied")

    local rank = Rank:__new()
    self.ranks[rankId] = rank
    rank:addParent(parentId)

    for k, v in pairs(childIds) do
        rank:addChild(v)
        self.ranks[v]:addParent(rankId)
    end

    return rank
end

-- Remove a rank and remove it as a parent from all of its children
function RankingTree:removeRank()
end

function RankingTree:doesInsertionCreateCycle(parentId, childIds)
    -- Firstly check if any of the children are an ancestor of the parent.
    -- As the vertice is being inserted into a tree, an ancestor of the parent will also be its ancestor.
    -- If it is then the graph will become cyclic when the vertice is inserted and we should create an error.

    local hasCycle = false
    local function findChildren(vertexIds)
        for k, vertexId in pairs(vertexIds) do
            if vertexId == parentId then
                hasCycle = true
                return
            end
            findChildren(self.Ranks[vertexId]:getChildren())
        end
    end

    findChildren(childIds)

    return hasCycle
end

-- We want ranks to be stored in a tree, not a graph with cycles.
-- Otherwise it will likely be confusing for those that run an organisation
function RankingTree:isAcyclic()
end