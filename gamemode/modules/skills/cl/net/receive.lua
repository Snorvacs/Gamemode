GM:AddHook( "InitPostEntity", "SendPlayerLevels", function()
	net.Start( "SendPlayerLevels" )
	net.SendToServer()
end )

net.Receive( "SendPlayerLevels", function()
	for _, skill in ipairs( GAMEMODE.Skills ) do
		LocalPlayer()[ skill:GetName() .. "Level" ] = net.ReadUInt( 7 )
		LocalPlayer()[ skill:GetName() .. "Exp" ] = net.ReadUInt( 26 )
	end
end )

net.Receive( "SendPlayerLevel", function()
	local skill = GAMEMODE.Skills[ net.ReadUInt( 6 ) ]
	LocalPlayer()[ skill:GetName() .. "Level" ] = net.ReadUInt( 7 )
end )

net.Receive( "SendPlayerExp", function()
	local skill = GAMEMODE.Skills[ net.ReadUInt( 6 ) ]
	LocalPlayer()[ skill:GetName() .. "Exp" ] = net.ReadUInt( 26 )
end )