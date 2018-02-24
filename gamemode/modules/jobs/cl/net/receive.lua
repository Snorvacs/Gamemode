GM:AddHook( "InitPostEntity", "SendPlayerJobLevels", function()
	net.Start( "SendPlayerJobLevels" )
	net.SendToServer()
end )

net.Receive( "SendPlayerJobLevels", function()
	for _, job in ipairs( GAMEMODE.JobSkills ) do
		LocalPlayer()[ job:GetName() .. "Level" ] = net.ReadUInt( 7 )
		LocalPlayer()[ job:GetName() .. "Exp" ] = net.ReadUInt( 26 )
	end
end )

net.Receive( "SendPlayerJobLevel", function()
	local job = GAMEMODE.JobSkills[ net.ReadUInt( 6 ) ]
	print(LocalPlayer()[ job:GetName() .. "Level" ])
	LocalPlayer()[ job:GetName() .. "Level" ] = net.ReadUInt( 7 )
end )

net.Receive( "SendPlayerJobExp", function()
	local job = GAMEMODE.JobSkills[ net.ReadUInt( 6 ) ]
	LocalPlayer()[ job:GetName() .. "Exp" ] = net.ReadUInt( 26 )
end )