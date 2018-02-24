local meta = FindMetaTable( "Player" )

function GmJobSkill:SetName( name )
	self.Name = name
end

function GmJobSkill:GetName()
	return self.Name
end

function GmJobSkill:SetPremium( premium )
	self.Premium = premium
end

function GmJobSkill:GetPremium()
	return self.Premium
end

function GmJobSkill:SetGuide( guide )
	self.Guide = guide
end

function GmJobSkill:GetGuide()
	return self.Guide
end

function GmJobSkill:SetUnlocks( unlocks )
	self.Unlocks = unlocks
end

function GmJobSkill:GetUnlocks()
	return self.Unlocks
end

function GmJobSkill:SetIcon( icon )
	self.Icon = icon
end

function GmJobSkill:GetIcon()
	return self.Icon
end

function GmJobSkill:SetPlayerLevel( level )
	self.PlayerLevel = level
end

function GmJobSkill:GetPlayerLevel()
	return self.PlayerLevel
end

function GmJobSkill:Create()
	local GM = GM or GAMEMODE
	GM.JobSkills[ #GM.JobSkills + 1 ] = self

	local index = #GM.JobSkills

	if SERVER then
		self:CreateSaveFuncs( index )
	else
		meta[ "Get" .. self.Name .. "Exp" ] = function( ply )
			return ply[ self.Name .. "Exp" ] or 0
		end

		meta[ "Get" .. self.Name .. "Level" ] = function( ply )
			return ply[ self.Name .. "Level" ] or 0
		end
	end
end

if CLIENT then
	function meta.GetJobLevel( ply, index )
		return ply[ GAMEMODE.JobSkills[ index ]:GetName() .. "Level" ] or 0
	end

	function meta.GetJobExp( ply, index )
		return ply[ GAMEMODE.JobSkills[ index ]:GetName() .. "Exp" ] or 0
	end
end

local dir = GM.FolderName .. "/gamemode/modules/jobs/sh/creation/jobs/"

local files, directories = file.Find( dir .. "*", "LUA" )

for _, _file in ipairs( files ) do
	if !_file:EndsWith( ".lua" ) then continue end

	include( dir .. _file )
end