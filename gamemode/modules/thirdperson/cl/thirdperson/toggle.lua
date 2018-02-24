local WasKeyDown = false

GM:AddHook( "Think", "OpenThirdPerson", function()
	local IsKeyDown = input.IsKeyDown( KEY_F3 )

	if IsKeyDown and !WasKeyDown then
		WasKeyDown = true
		GAMEMODE:ToggleThirdPerson()
	elseif !IsKeyDown then
		WasKeyDown = false
	end
end )