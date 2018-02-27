local rt = GM.Runtime.require("./rank.lua").RankingTree
local rtTest = rt:__new()


-- Tests for RankingTree:addRank --
local default = rtTest:addRank("default")
local secondRank = rtTest:addRank("second_rank", "default")

assert(default:hasChild("second_rank"))
assert(table.Count(default:getParents()) == 0)
assert(table.Count(default:getChildren()) == 1)
assert(secondRank:hasParent("default"))
assert(table.Count(secondRank:getParents()) == 1)
assert(table.Count(secondRank:getChildren()) == 0)
assert(rtTest.root == default)


local thirdRank = rtTest:addRank("third_rank", "second_rank")

assert(default:hasChild("second_rank"))
assert(table.Count(default:getParents()) == 0)
assert(table.Count(default:getChildren()) == 1)
assert(secondRank:hasParent("default"))
assert(table.Count(secondRank:getParents()) == 1)
assert(table.Count(secondRank:getChildren()) == 1)
assert(rtTest.root == default)
assert(secondRank:hasChild("third_rank"))

-- Tests for RankingTree:insertRank --
local rtTest = rt:__new()
local default = rtTest:addRank("default")
local one = rtTest:addRank("one", "default")
local two = rtTest:insertRank("two", "default", {"one"})
assert(default:hasChild("two"))
assert(one:hasParent("two"))
assert(two:hasParent("default"))
assert(two:hasChild("one"))

assert(table.Count(default:getChildren()) == 1)
assert(table.Count(two:getChildren()) == 1)
assert(table.Count(one:getChildren()) == 0)

assert(table.Count(default:getParents()) == 0)
assert(table.Count(two:getParents()) == 1)
assert(table.Count(one:getParents()) == 1)

-- TODO: Tests for cycles in graph

-- Tests for RankingTree:removeRank --

local rtTest = rt:__new()
local default = rtTest:addRank("default")
local one = rtTest:addRank("one", "default")
local two = rtTest:addRank("two", "one")

rtTest:removeRank("one")

assert(table.Count(default:getChildren()) == 0)
assert(table.Count(rtTest:getRanks()) == 1)

PrintTable(rtTest)