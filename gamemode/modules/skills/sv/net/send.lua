util.AddNetworkString( "SendPlayerLevels" )
util.AddNetworkString( "SendPlayerLevel" )
util.AddNetworkString( "SendPlayerExp" )

net.Receive( "SendPlayerLevels", function( len, ply )
	if ply.ReceivedLevels then return end
	ply.ReceivedLevels = true

	net.Start( "SendPlayerLevels" )
		for i, skill in ipairs( GAMEMODE.Skills ) do
			net.WriteUInt( ply:GetLevel( i ), 7 )
			net.WriteUInt( ply:GetExp( i ), 26 )
		end
	net.Send( ply )
end )