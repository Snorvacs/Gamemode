local GradientSide = Material( "gui/gradient" )
local GradientUp = Material( "gui/gradient_up" )
local GradientDown = Material( "gui/gradient_down" )

surface.CreateFont( "cgTitleFont", {
	font = "Roboto",
	size = 32 * ( ScrH() / 1080 )
} )

surface.CreateFont( "cgMedFont", {
	font = "Roboto",
	size = 27 * ( ScrH() / 1080 )
} )

surface.CreateFont( "cgSmallFont", {
	font = "Roboto",
	size = 24 * ( ScrH() / 1080 )
} )

function GM:CreateMainMenu()
	self.MainMenu = vgui.Create( "EditablePanel" )
	self.MainMenu:SetSize( ScrW() * 0.85, ScrH() * 0.85 )
	self.MainMenu:Center()
	self.MainMenu:SetMouseInputEnabled( true )
	self.MainMenu:SetKeyboardInputEnabled( true )

	function self.MainMenu.Paint( panel, w, h )
		surface.SetDrawColor( Color( 25, 25, 25 ) )
		surface.DrawRect( 0, 0, w, h )
	end

	function self.MainMenu.Think( panel )
		if input.IsKeyDown( KEY_ESCAPE ) then
			GAMEMODE:ToggleMainMenu()
		end

		GAMEMODE:Resize( self.MainMenu )
	end

	self.MainMenu:Hide()

	local NavBar = vgui.Create( "DPanel", self.MainMenu )
	NavBar:Dock( LEFT )
	NavBar:DockMargin( 0, 0, self.MainMenu:GetWide() / 80, 0 )
	NavBar:SetWidth( self.MainMenu:GetWide() * 0.16 )
	NavBar:InvalidateParent( true )

	local SelectedPanel = 1
	local PrevPos = 0

	function NavBar.Paint( panel, w, h )
		surface.SetDrawColor( Color( 26, 26, 26 ) )
		surface.DrawRect( 0, 0, w, h )

		DisableClipping( true )
			surface.SetDrawColor( Color( 0, 0, 0, 90 ) )
			surface.SetMaterial( GradientSide )
			surface.DrawTexturedRect( w, 0, self.MainMenu:GetWide() / 140, h )
		DisableClipping( false )

		local height = Lerp( RealFrameTime() * 15, PrevPos, SelectedPanel * panel:GetTall() * 0.055 + self.MainMenu:GetTall() / 120 )
		PrevPos = height

		surface.SetDrawColor( Color( 60, 60, 60 ) )
		surface.DrawRect( 0, height, panel:GetWide() * 0.025, panel:GetTall() * 0.055 )
	end

	local ParentPanel = vgui.Create( "DPanel", self.MainMenu )
	ParentPanel:Dock( FILL )
	ParentPanel:InvalidateParent( true )
	function ParentPanel.Paint() end

	local NavTitle = vgui.Create( "DPanel", NavBar )
	NavTitle:Dock( TOP )
	NavTitle:DockMargin( 0, 0, 0, self.MainMenu:GetTall() / 120 )
	NavTitle:SetHeight( NavBar:GetTall() * 0.055 )

	function NavTitle.Paint( panel, w, h )
		surface.SetDrawColor( Color( 27, 27, 27 ) )
		surface.DrawRect( 0, 0, w, h )

		draw.SimpleText( "Colossal Gaming", "cgTitleFont", w / 2, h / 2, Color( 235, 235, 235 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		DisableClipping( true )
			surface.SetDrawColor( Color( 0, 0, 0, 90 ) )
			surface.SetMaterial( GradientDown )
			surface.DrawTexturedRect( 0, h, w, self.MainMenu:GetTall() / 120 )
		DisableClipping( false )
	end

	for i, tbl in ipairs( self.MenuPanels ) do
		local info = tbl.info
		self.MenuPanels[ i ].panel = vgui.Create( info.type or "DScrollPanel", ParentPanel )

		local panel = self.MenuPanels[ i ].panel
		panel:SetSize( ParentPanel:GetWide(), ParentPanel:GetTall() )
		if panel.GetCanvas then
			panel:GetCanvas():DockPadding( 0, self.MainMenu:GetWide() / 80, self.MainMenu:GetWide() / 80, self.MainMenu:GetWide() / 80 )
		else
			panel:DockPadding( 0, self.MainMenu:GetWide() / 80, self.MainMenu:GetWide() / 80, self.MainMenu:GetWide() / 80 )
		end

		function panel:Paint() end

		if panel.GetVBar then
			local VBar = panel:GetVBar()
			VBar:SetHideButtons( true )

			function VBar:Paint() end

			function VBar.btnGrip.Paint( panel, w, h )
				surface.SetDrawColor( 30, 30, 30, 255 )
				surface.DrawRect( 0, 0, w, h )
			end
		end

		tbl.callback( self, panel )

		panel:Hide()

		panel = vgui.Create( "DButton", NavBar )
		panel:Dock( TOP )
		panel:SetText( "" )
		panel:SetHeight( NavBar:GetTall() * 0.055 )

		function panel.Paint( panel, w, h )
			draw.SimpleText( info.name, "cgMedFont", w / 2, h / 2, Color( 235, 235, 235 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		function panel.DoClick( panel )
			surface.PlaySound( "garrysmod/ui_click.wav" )
			self.MenuPanels[ SelectedPanel ].panel:Hide()
			SelectedPanel = i
			self.MenuPanels[ SelectedPanel ].panel:Show()
		end

		function panel.OnCursorEntered( panel )
			surface.PlaySound( "garrysmod/ui_hover.wav" )
		end
	end

	self.MenuPanels[ 1 ].panel:Show()

	local CloseButton = vgui.Create( "DButton", NavBar )
	CloseButton:Dock( BOTTOM )
	CloseButton:SetText( "" )
	CloseButton:SetHeight( NavBar:GetTall() * 0.055 )

	function CloseButton.Paint( panel, w, h )
		draw.SimpleText( "Close", "cgSmallFont", w / 2, h / 2, Color( 235, 235, 235 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	function CloseButton.DoClick( panel )
		surface.PlaySound( "garrysmod/ui_click.wav" )
		GAMEMODE:ToggleMainMenu()
	end

	function CloseButton.OnCursorEntered( panel )
		surface.PlaySound( "garrysmod/ui_hover.wav" )
	end
end

function GM:ToggleMainMenu()
	GAMEMODE:Resize( self.MainMenu )
	self.MainMenu:ToggleVisible()
	gui.EnableScreenClicker( self.MainMenu:IsVisible() )
end

local PrevRes = ScrH()

function GM:Resize( panel )
	if PrevRes == ScrH() then return end

	surface.CreateFont( "cgTitleFont", {
		font = "Roboto",
		size = 32 * ( ScrH() / 1080 )
	} )

	surface.CreateFont( "cgMedFont", {
		font = "Roboto",
		size = 27 * ( ScrH() / 1080 )
	} )

	surface.CreateFont( "cgSmallFont", {
		font = "Roboto",
		size = 24 * ( ScrH() / 1080 )
	} )

	local Factor = PrevRes / ScrH()

	local x, y, w, h = panel:GetBounds()

	panel:SetPos( x / Factor, y / Factor )
	panel:SetSize( w / Factor, h / Factor )

	local function ResizeChildren( panel )
		for _, child in ipairs( panel:GetChildren() ) do
			local x, y, w, h = child:GetBounds()

			child:SetPos( x / Factor, y / Factor )
			child:SetSize( w / Factor, h / Factor )

			if child.OnResize then
				child:OnResize()
			end

			if istable( child:GetChildren() ) and child:GetChildren()[ 1 ] then
				ResizeChildren( child )
			end
		end
	end

	ResizeChildren( panel )

	PrevRes = ScrH()
end

GM:AddHook( "InitPostEntity", "LoadMainMenu", GM.CreateMainMenu )

GM:AddHook( "OnReloaded", "RefreshMainMenu", function()
	if IsValid( GAMEMODE.MainMenu ) and GAMEMODE.MainMenu:IsVisible() then
		GAMEMODE.MainMenu:Remove()
		GAMEMODE:CreateMainMenu()
		GAMEMODE.MainMenu:Show()
	else
		GAMEMODE:CreateMainMenu()
	end
end )