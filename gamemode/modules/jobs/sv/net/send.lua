util.AddNetworkString( "SendPlayerJobLevels" )
util.AddNetworkString( "SendPlayerJobLevel" )
util.AddNetworkString( "SendPlayerJobExp" )

net.Receive( "SendPlayerJobLevels", function( len, ply )
	net.Start( "SendPlayerJobLevels" )
		for i, skill in ipairs( GAMEMODE.JobSkills ) do
			net.WriteUInt( ply:GetJobLevel( i ), 7 )
			net.WriteUInt( ply:GetJobExp( i ), 26 )
		end
	net.Send( ply )
end )