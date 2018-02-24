GM.Name = "wowwhatsthis"
GM.Author = "Badger"
GM.Website = "http://colossalgamingau.com"
GM.TeamBased = false
GM.Runtime = include( "libraries/runtime.lua" )

DeriveGamemode( "base" )
DEFINE_BASECLASS( "gamemode_base" )

-- Enumerations

include( "enums.lua" )

-- Libraries

include( "libraries/gmhook.lua" )

-- Modules

include( "modules/menu/load.lua" )
include( "modules/skills/load.lua" )
include( "modules/jobs/load.lua" )
include( "modules/thirdperson/load.lua" )
include( "modules/inventory/load.lua" )