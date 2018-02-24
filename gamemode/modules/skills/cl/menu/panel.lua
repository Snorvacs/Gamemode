GM:AddMenuPanel( { name = "Skills" }, function( self, parent )
	local Open = 1

	local panel = vgui.Create( "DPanel", parent )
	panel:Dock( TOP )
	panel:SetTall( parent:GetTall() * 0.04 )
	panel:InvalidateParent( true )
	panel:DockMargin( 0, 0, 0, panel:GetTall() * 0.2 )

	function panel:Paint( w, h )
		surface.SetDrawColor( Color( 26, 26, 26 ) )
		surface.DrawRect( 0, 0, w, h )
	end

	local size = panel:GetTall()

	local button = vgui.Create( "DPanel", panel )
	button:Dock( TOP )
	button:SetText( "" )
	button:SetTall( size )
	button:InvalidateParent( true )

	function button:Paint( w, h )
		draw.SimpleText( "Skill", "cgMedFont", w / 70, h / 2, Color( 235, 235, 235 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Level", "cgMedFont", w / 7, h / 2, Color( 235, 235, 235 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

		draw.SimpleText( "Experience", "cgMedFont", w / 6.5 + w * 0.83 / 2, h / 2, Color( 235, 235, 235 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	local function map( n, start1, stop1, start2, stop2 )
		return ( ( n - start1 ) / ( stop1 - start1 ) ) * ( stop2 - start2 ) + start2
	end

	for i, skill in ipairs( self.Skills ) do
		local panel = vgui.Create( "DPanel", parent )
		panel:Dock( TOP )
		panel:SetTall( parent:GetTall() * 0.085 )
		panel:InvalidateParent( true )
		panel:DockMargin( 0, 0, 0, panel:GetTall() * 0.2 )

		function panel:Paint( w, h )
			surface.SetDrawColor( Color( 26, 26, 26 ) )
			surface.DrawRect( 0, 0, w, h )
		end

		local size = panel:GetTall()
		local Clicked = false
		local Done = false

		function panel:OnResize()
			if Clicked then
				size = self:GetTall() / 6
			else
				size = self:GetTall()
			end
		end

		local button = vgui.Create( "DButton", panel )
		button:Dock( TOP )
		button:SetText( "" )
		button:SetTall( size )
		button:InvalidateParent( true )

		function button:DoClick()
			surface.PlaySound( "garrysmod/ui_click.wav" )
			Clicked = !Clicked
			Open = i
		end

		function button:Think()
			if Open != i then
				Clicked = false
			end

			if Clicked then
				panel:SetTall( math.ceil( Lerp( FrameTime() * 10, panel:GetTall(), size * 6 ) ) )
			else
				panel:SetTall( math.floor( Lerp( FrameTime() * 10, panel:GetTall(), size ) ) )
			end
		end

		local PrevVal

		function button:Paint( w, h )
			draw.SimpleText( skill:GetName(), "cgSmallFont", w / 70, h / 2, Color( 235, 235, 235 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( tostring( LocalPlayer():GetLevel( i ) ), "cgSmallFont", w / 7, h / 2, Color( 235, 235, 235 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

			if LocalPlayer():GetLevel( i ) == 99 then
				surface.SetDrawColor( 200, 200, 200, 11 )
				surface.DrawRect( w / 6.5, h / 2 - h * 0.3, w * 0.83, h * 0.6 )
			return else
				surface.SetDrawColor( 200, 200, 200, 1 )
				surface.DrawRect( w / 6.5, h / 2 - h * 0.3, w * 0.83, h * 0.6 )
			end

			if !PrevVal then
				PrevVal = map( LocalPlayer():GetExp( i ), 0, GAMEMODE.LevelValues[ LocalPlayer():GetLevel( i ) + 1 ], 0, w * 0.83 )
			end

			local Val = math.Clamp( PrevVal + 8, 0, map( LocalPlayer():GetExp( i ), 0, GAMEMODE.LevelValues[ LocalPlayer():GetLevel( i ) + 1 ], 0, w * 0.83 ) )
			PrevVal = Val

			surface.SetDrawColor( 200, 200, 200, 10 )
			surface.DrawRect( w / 6.5, h / 2 - h * 0.3, Val, h * 0.6 )

			draw.SimpleText( tostring( LocalPlayer():GetExp( i ) ) .. "/" .. tostring( GAMEMODE.LevelValues[ LocalPlayer():GetLevel( i ) + 1 ] ), "cgSmallFont", w / 6.5 + w * 0.83 / 2, h / 2, Color( 235, 235, 235 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		function button:OnCursorEntered()
			surface.PlaySound( "garrysmod/ui_hover.wav" )
		end

		local nParent = vgui.Create( "DPanel", panel )
		nParent:Dock( FILL )
		nParent:DockMargin( panel:GetTall() * 0.15, panel:GetTall() * 0.05, panel:GetTall() * 0.15, panel:GetTall() * 0.15 )
		nParent:InvalidateParent( true )

		function nParent:Paint( w, h )
			surface.SetDrawColor( 25, 25, 25 )
			surface.DrawRect( 0, 0, w, h )
		end

		function nParent:Think()
			self:Dock( FILL )
		end

		local NavBar = vgui.Create( "DPanel", nParent )
		NavBar:Dock( TOP )
		NavBar:SetTall( panel:GetTall() * 0.8 )
		NavBar:InvalidateParent( true )

		local PrevPos = 0
		local SelectedPanel = 0

		function NavBar:Paint( w, h )
			surface.SetDrawColor( 26, 26, 26 )
			surface.DrawRect( 0, 0, w, h )

			local x = Lerp( RealFrameTime() * 15, PrevPos, SelectedPanel * ( w / 2 ) )
			PrevPos = x

			surface.SetDrawColor( Color( 60, 60, 60 ) )
			surface.DrawRect( x, h - self:GetTall() * 0.07, self:GetWide() / 2, self:GetTall() * 0.07 )
		end

		local UnlocksPanel, GuidePanel

		local GuideButton = vgui.Create( "DButton", NavBar )
		GuideButton:Dock( LEFT )
		GuideButton:SetText( "" )
		GuideButton:SetWide( NavBar:GetWide() / 2 )
		GuideButton:SetTall( panel:GetTall() * 0.6 )

		function GuideButton:Paint( w, h )
			draw.SimpleText( "Guide", "cgSmallFont", w / 2, h / 2, Color( 235, 235, 235 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		function GuideButton:DoClick()
			UnlocksPanel:Hide()
			GuidePanel:Show()
			SelectedPanel = 0
			surface.PlaySound( "garrysmod/ui_click.wav" )
		end

		function GuideButton:OnCursorEntered()
			surface.PlaySound( "garrysmod/ui_hover.wav" )
		end

		local UnlocksButton = vgui.Create( "DButton", NavBar )
		UnlocksButton:Dock( LEFT )
		UnlocksButton:SetText( "" )
		UnlocksButton:SetWide( NavBar:GetWide() / 2 )
		UnlocksButton:SetTall( panel:GetTall() * 0.6 )

		function UnlocksButton:Paint( w, h )
			draw.SimpleText( "Unlocks", "cgSmallFont", w / 2, h / 2, Color( 235, 235, 235 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		function UnlocksButton:DoClick()
			UnlocksPanel:Show()
			GuidePanel:Hide()
			SelectedPanel = 1
			surface.PlaySound( "garrysmod/ui_click.wav" )
		end

		function UnlocksButton:OnCursorEntered()
			surface.PlaySound( "garrysmod/ui_hover.wav" )
		end

		local InfoPanel = vgui.Create( "DPanel", nParent )
		InfoPanel:Dock( FILL )
		InfoPanel:InvalidateParent( true )

		function InfoPanel:Paint() end

		function InfoPanel:Think()
			self:Dock( FILL )
			self:InvalidateParent()
		end

		UnlocksPanel = vgui.Create( "DScrollPanel", InfoPanel )
		UnlocksPanel:SetSize( InfoPanel:GetWide(), InfoPanel:GetTall() )

		local VBar = UnlocksPanel:GetVBar()
		VBar:SetHideButtons( true )

		function VBar:Paint() end

		function VBar.btnGrip.Paint( panel, w, h )
			surface.SetDrawColor( 30, 30, 30, 255 )
			surface.DrawRect( 0, 0, w, h )
		end

		function UnlocksPanel:Think()
			self:SetTall( InfoPanel:GetTall() )
		end

		local UnlockInfoPanel = vgui.Create( "DPanel", UnlocksPanel )
		UnlockInfoPanel:Dock( TOP )
		UnlockInfoPanel:SetTall( panel:GetTall() * 0.75 )
		UnlockInfoPanel:InvalidateParent( true )

		function UnlockInfoPanel:Paint( w, h )
			surface.SetDrawColor( Color( 26, 26, 26 ) )
			surface.DrawRect( 0, 0, w, h )

			draw.SimpleText( "Name", "cgSmallFont", w / 70, h / 2, Color( 235, 235, 235 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( "Level", "cgSmallFont", w / 7, h / 2, Color( 235, 235, 235 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			draw.SimpleText( "Status", "cgSmallFont", w - w / 3, h / 2, Color( 235, 235, 235 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		for _, unlock in ipairs( skill:GetUnlocks() ) do
			local UnlockPanel = vgui.Create( "DPanel", UnlocksPanel )
			UnlockPanel:Dock( TOP )
			UnlockPanel:SetTall( panel:GetTall() * 0.75 )
			UnlockPanel:InvalidateParent( true )
			UnlockPanel:DockMargin( 0, panel:GetTall() * 0.2, 0, 0 )

			function UnlockPanel:Paint( w, h )
				surface.SetDrawColor( Color( 26, 26, 26 ) )
				surface.DrawRect( 0, 0, w, h )

				local col = Color( 235, 235, 235 )

				if LocalPlayer():GetLevel( i ) >= unlock.level then
					draw.SimpleText( "Unlocked", "cgSmallFont", w - w / 3, h / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				else
					col = Color( 135, 135, 135 )
					draw.SimpleText( "Locked", "cgSmallFont", w - w / 3, h / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end

				draw.SimpleText( unlock.name, "cgSmallFont", w / 70, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( unlock.level, "cgSmallFont", w / 7, h / 2, col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			end
		end

		UnlocksPanel:Hide()

		GuidePanel = vgui.Create( "DHTML", InfoPanel )
		GuidePanel:SetSize( InfoPanel:GetWide(), InfoPanel:GetTall() )
		GuidePanel:OpenURL( "https://www.google.com.au/" )

		function GuidePanel:Think()
			self:SetTall( InfoPanel:GetTall() )
		end
	end
end )