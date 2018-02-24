GM.Name = "wowwhatsthis?"
GM.Author = "Badger"
GM.Website = "http://colossalgamingau.com"
GM.TeamBased = false
GM.Runtime = include( "libraries/runtime.lua" )

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "enums.lua" )

include( "content.lua" )

DeriveGamemode( "base" )
DEFINE_BASECLASS( "gamemode_base" )

local function AddClientsideLua( dir )
	local files, directories = file.Find( dir .. "*", "LUA" )

	for _, _file in ipairs( files ) do
		if !_file:EndsWith( ".lua" ) then continue end

		AddCSLuaFile( dir .. _file )
	end

	for _, _dir in ipairs( directories ) do
		if _dir == "sv" then continue end
		AddClientsideLua( dir .. _dir .. "/" )
	end
end

AddClientsideLua( GM.FolderName .. "/gamemode/modules/" )
AddClientsideLua( GM.FolderName .. "/gamemode/libraries/" )

-- Enumerations

include( "enums.lua" )

-- Libraries

include( "libraries/gmhook.lua" )

-- Modules

include( "modules/skills/load.lua" )
include( "modules/jobs/load.lua" )
include( "modules/inventory/load.lua" )