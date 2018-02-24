local meta = FindMetaTable( "Player" )

function GmSkill:SetName( name )
	self.Name = name
end

function GmSkill:GetName()
	return self.Name
end

function GmSkill:SetPremium( premium )
	self.Premium = premium
end

function GmSkill:GetPremium()
	return self.Premium
end

function GmSkill:SetGuide( guide )
	self.Guide = guide
end

function GmSkill:GetGuide()
	return self.Guide
end

function GmSkill:SetUnlocks( unlocks )
	self.Unlocks = unlocks
end

function GmSkill:GetUnlocks()
	return self.Unlocks
end

function GmSkill:SetIcon( icon )
	self.Icon = icon
end

function GmSkill:GetIcon()
	return self.Icon
end

function GmSkill:Create()
	local GM = GM or GAMEMODE
	GM.Skills[ #GM.Skills + 1 ] = self

	local index = #GM.Skills

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
	function meta.GetLevel( ply, index )
		return ply[ GAMEMODE.Skills[ index ]:GetName() .. "Level" ] or 0
	end

	function meta.GetExp( ply, index )
		return ply[ GAMEMODE.Skills[ index ]:GetName() .. "Exp" ] or 0
	end
end

local dir = GM.FolderName .. "/gamemode/modules/skills/sh/creation/skills/"

local files, directories = file.Find( dir .. "*", "LUA" )

for _, _file in ipairs( files ) do
	if !_file:EndsWith( ".lua" ) then continue end

	include( dir .. _file )
end