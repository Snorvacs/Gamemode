local WasKeyDown = false

GM:AddHook( "Think", "OpenMainMenu", function()
	local IsKeyDown = input.IsKeyDown( KEY_F4 ) or input.IsKeyDown( KEY_F1 )

	if IsKeyDown and !WasKeyDown then
		WasKeyDown = true
		GAMEMODE:ToggleMainMenu()
	elseif !IsKeyDown then
		WasKeyDown = false
	end
end )