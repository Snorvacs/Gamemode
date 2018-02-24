local meta = FindMetaTable( "Player" )

function meta:GiveJobLevel( index, amount )
	self[ "Give" .. GAMEMODE.JobSkills[ index ]:GetName() .. "Level" ]( self, amount )
end

function meta:GiveJobExp( index, amount )
	self[ "Give" .. GAMEMODE.JobSkills[ index ]:GetName() .. "Exp" ]( self, amount )
end

function meta.GetJobLevel( ply, index )
	return ply[ "Get" .. GAMEMODE.JobSkills[ index ]:GetName() .. "Level" ]( ply )
end

function meta.GetJobExp( ply, index )
	return ply[ "Get" .. GAMEMODE.JobSkills[ index ]:GetName() .. "Exp" ]( ply )
end

function GmJobSkill:CreateSaveFuncs( index )
	if !sql.TableExists( self.Name:lower() .. "exp" ) then
		sql.Query( "CREATE TABLE IF NOT EXISTS " .. self.Name:lower() .. "exp ( steamid TEXT NOT NULL PRIMARY KEY, value TEXT );" )
	end

	if !sql.TableExists( self.Name:lower() .. "level" ) then
		sql.Query( "CREATE TABLE IF NOT EXISTS " .. self.Name:lower() .. "level ( steamid TEXT NOT NULL PRIMARY KEY, value TEXT );" )
	end

	local Exp = self.Name .. "Exp"
	local Level = self.Name .. "Level"

	meta[ "Give" .. self.Name .. "Exp" ] = function( ply, amount )
		local CurrentExp = ply:GetJobExp( index )
		local CurrentLevel = ply:GetJobLevel( index )

		if CurrentLevel == 99 then return end

		ply[ Exp ] = CurrentExp + amount

		local levels = 0

		while GAMEMODE.LevelValues[ CurrentLevel + 1 ] <= ply[ Exp ] do
			ply[ Exp ] = ply[ Exp ] - GAMEMODE.LevelValues[ CurrentLevel + 1 ]
			levels = levels + 1
		end

		if levels > 0 then
			ply:GiveLevel( index, levels )
		end

		sql.Query( "REPLACE INTO " .. self.Name:lower() .. "exp ( steamid, value ) VALUES( " .. SQLStr( ply:SteamID() ) .. ", " .. SQLStr( ply[ Exp ] ) .. " )" )

		net.Start( "SendPlayerJobExp" )
			net.WriteUInt( index, 6 )
			net.WriteUInt( ply[ Exp ], 27 )
		net.Send( ply )
	end

	meta[ "Give" .. self.Name .. "Level" ] = function( ply, amount )
		local CurrentLevel = ply:GetJobLevel( index )

		if CurrentLevel == 99 then return end

		ply[ Level ] = CurrentLevel + amount

		sql.Query( "REPLACE INTO " .. self.Name:lower() .. "level ( steamid, value ) VALUES( " .. SQLStr( ply:SteamID() ) .. ", " .. SQLStr( ply[ Level ] ) .. " )" )

		net.Start( "SendPlayerJobLevel" )
			net.WriteUInt( index, 6 )
			net.WriteUInt( ply[ Level ], 7 )
		net.Send( ply )
	end

	meta[ "Get" .. self.Name .. "Exp" ] = function( ply )
		if ply[ Exp ] then
			return ply[ Exp ]
		end

		local QueryResult = sql.Query( "SELECT value FROM " .. self.Name:lower() .. "exp WHERE steamid = " .. SQLStr( ply:SteamID() ) )
		local amount = 0

		if istable( QueryResult ) then
			amount = tonumber( QueryResult[ 1 ].value )
		end

		ply[ Exp ] = amount

		return amount
	end

	meta[ "Get" .. self.Name .. "Level" ] = function( ply )
		if ply[ Level ] then
			return ply[ Level ]
		end

		local QueryResult = sql.Query( "SELECT value FROM " .. self.Name:lower() .. "level WHERE steamid = " .. SQLStr( ply:SteamID() ) )
		local amount = 1

		if istable( QueryResult ) then
			amount = tonumber( QueryResult[ 1 ].value )
		end

		return amount
	end
end