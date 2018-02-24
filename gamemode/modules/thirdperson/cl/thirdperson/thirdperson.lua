local On = false

function GM:ToggleThirdPerson()
	On = !On
end

GM:AddHook( "CalcView", "ThirdPerson", function( self, ply, origin, angle, fov )
	if !On then return end

	local view = {}

	view.origin = origin - ( angle:Forward() * 100 ) + ( angle:Up() * 5 ) + ( angle:Right() * 15 )
	view.angles = angles
	view.fov = fov
	view.drawviewer = true

	return view
end )