local runtime, exports = ...

local Rank = runtime.oop.create("Rank")
exports["Rank"] = Rank

function Rank:__ctor()
    self.parents = {}
    self.children = {}
end

function Rank:getParents()
    return self.parents
end

function Rank:hasParent(parentId)
    return self.parents[parentId]
end

function Rank:addParent(parentId)
    self.parents[parentId] = true
end

function Rank:removeParent(parentId)
    self.parents[parentId] = nil
end

function Rank:getChildren()
    return self.children
end

function Rank:hasChild(childId)
    return self.children[childId]
end

function Rank:addChild(childId)
    self.children[childId] = true
end

function Rank:removeChild(childId)
    self.children[childId] = nil
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
    assert(not self.ranks[rankId], "A rank with this Id already exists inside of the tree")
    assert(parentId or not self.root, "A root node already already exists on this tree")
    assert(isstring(rankId), "Ranks can only be created with a string as its identifier")
    assert(not parentId or isstring(parentId), "Ranks can only be created with a string as its identifier")

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
        assert(self.ranks[v], "An invalid identifier for a child was supplied")
    end
    assert(self.ranks[parentId], "An invalid identifer for the parent was supplied")

    local rank = Rank:__new()
    self.ranks[rankId] = rank
    rank:addParent(parentId)
    self.ranks[parentId]:addChild(rankId)

    for k, childId in pairs(childIds) do
        local child = self.ranks[childId]
        
        if child:hasParent(parentId) then
            self.ranks[parentId]:removeChild(childId)
            child:removeParent(parentId)
        end

        rank:addChild(childId)
        child:addParent(rankId)
    end

    return rank
end

-- Remove a rank and remove it as a parent from all of its children
function RankingTree:removeRank(rankId)
    
    for k, v in pairs(self.ranks[rankId]:getChildren()) do
        self.ranks[v]:removeParent(rankId)
    end
    self.ranks[rankId] = nil

    local found = false
    repeat
        for k, v in pairs(self.ranks) do
            if table.Count(v:getParents()) == 0 and v ~= self.root then
                for child, _ in pairs(v:getChildren()) do
                    self.ranks[child]:removeParent(k)
                end
                self.ranks[k] = nil
                found = true
            end
        end
    until not found
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
            findChildren(self.ranks[vertexId]:getChildren())
        end
    end

    findChildren(childIds)

    return hasCycle
end

-- We want ranks to be stored in a tree, not a graph with cycles.
-- Otherwise it will likely be confusing for those that run an organisation
function RankingTree:isAcyclic()
end