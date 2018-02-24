function GM:CreateInventory()
    self.invParent = vgui.Create( "EditablePanel" )
    self.invParent:SetSize( ScrW() * 0.4, ScrH() * 0.45 )
    self.invParent:SetPos( -ScrW() * 0.4, 0 )
    self.invParent:DockPadding( self.invParent:GetWide() * 0.01, self.invParent:GetWide() * 0.01, self.invParent:GetWide() * 0.01, self.invParent:GetWide() * 0.01 )

    function self.invParent:Paint( w, h )
        surface.SetDrawColor( Color( 26, 26, 26, 155 ) )
        surface.DrawRect( 0, 0, w, h )
    end

    local inventoryPanel = vgui.Create( "DPanel", self.invParent )
    inventoryPanel:Dock( LEFT )
    inventoryPanel:SetWide( self.invParent:GetWide() * 0.65 )
    inventoryPanel:InvalidateParent( true )
    inventoryPanel:DockMargin( 0, 0, self.invParent:GetTall() * 0.02, 0 )
    inventoryPanel:DockPadding( 0, self.invParent:GetTall() * 0.01, 0, 0 )

    function inventoryPanel:Paint( w, h )
        surface.SetDrawColor( Color( 26, 26, 26, 155 ) )
        surface.DrawRect( 0, 0, w, h )
    end

    local inventoryPanels = {}
    local panel, row
    local rowHeight = inventoryPanel:GetTall() / 5 - self.invParent:GetTall() * 0.01
    local columnWidth = inventoryPanel:GetWide() / 5 - self.invParent:GetTall() * 0.01

    for r = 1, 5 do
        inventoryPanels[ r ] = {}

        row = vgui.Create( "DPanel", inventoryPanel )
        row:Dock( TOP )
        row:SetTall( rowHeight )
        row:DockMargin( 0, 0, 0, self.invParent:GetTall() * 0.01 )
        row:DockPadding( self.invParent:GetTall() * 0.01, 0, 0, 0 )
        
        function row:Paint() end

        for c = 1, 5 do
            inventoryPanels[ r ][ c ] = vgui.Create( "InventorySlot", row )
            panel = inventoryPanels[ r ][ c ]
            panel:Dock( LEFT )
            panel:SetWide( columnWidth )
            panel:DockMargin( 0, 0, self.invParent:GetTall() * 0.01, 0 )
            panel:SetAlpha( 155 )
        end
    end

    local playerPanel = vgui.Create( "DPanel", self.invParent )
    playerPanel:Dock( FILL )
    playerPanel:InvalidateParent( true )
    playerPanel:DockPadding( 0, self.invParent:GetTall() * 0.005, 0, 0 )

    function playerPanel:Paint( w, h )
        surface.SetDrawColor( Color( 26, 26, 26, 155 ) )
        surface.DrawRect( 0, 0, w, h )
    end

    local playerPanels = {}

    columnWidth = playerPanel:GetWide() / 4 - self.invParent:GetTall() * 0.01

    for r = 1, 2 do
        playerPanels[ r ] = {}

        row = vgui.Create( "DPanel", playerPanel )
        row:Dock( BOTTOM )
        row:SetTall( columnWidth )
        row:DockMargin( 0, 0, 0, self.invParent:GetTall() * 0.01 )
        row:DockPadding( self.invParent:GetTall() * 0.01, 0, 0, 0 )
        
        function row:Paint() end

        for c = 1, 4 do
            playerPanels[ r ][ c ] = vgui.Create( "InventorySlot", row )
            panel = playerPanels[ r ][ c ]
            panel:Dock( LEFT )
            panel:SetWide( columnWidth )
            panel:DockMargin( 0, 0, self.invParent:GetTall() * 0.01, 0 )
            panel:SetAlpha( 155 )
        end
    end

    local name = vgui.Create( "DLabel", playerPanel )
    name:SetFont( "cgMedFont" )
    name:SetTextColor( Color( 235, 235, 235, 155 ) )
    name:Dock( TOP )
    name:SetTall( playerPanel:GetTall() * 0.07 )
    name:SetContentAlignment( 8 )
    name:SetText( LocalPlayer():Nick() )

    local playerModel = vgui.Create( "DModelPanel", playerPanel )
    playerModel:Dock( FILL )
    playerModel:DockMargin( 0, 0, 0, GAMEMODE.invParent:GetTall() * 0.01 )
    playerModel:SetModel( LocalPlayer():GetModel() )
    playerModel:SetCamPos( playerModel:GetCamPos() - Vector( 4, 40, -7 ) )

    function playerModel:Think()
        self:SetModel( LocalPlayer():GetModel() )
    end

    function playerModel:LayoutEntity() return end

    if IsValid( self.bankParent ) then self.invParent:Remove() end

    self.bankParent = vgui.Create( "EditablePanel" )
    self.bankParent:SetSize( ScrW() * 0.4, ScrH() * 0.45 )
    self.bankParent:SetPos( ScrW(), 0 )
    self.bankParent:DockPadding( self.bankParent:GetWide() * 0.01, self.bankParent:GetWide() * 0.001, self.bankParent:GetWide() * 0.01, self.bankParent:GetWide() * 0.01 )

    function self.bankParent:Paint( w, h )
        surface.SetDrawColor( Color( 26, 26, 26, 155 ) )
        surface.DrawRect( 0, 0, w, h )
    end

    local bankLabel = vgui.Create( "DLabel", self.bankParent )
    bankLabel:Dock( TOP )
    bankLabel:SetTall( self.bankParent:GetTall() * 0.06 )
    bankLabel:SetFont( "cgMedFont" )
    bankLabel:SetTextColor( Color( 235, 235, 235, 155 ) )
    bankLabel:SetContentAlignment( 8 )
    bankLabel:SetText( "Bank Account" )

    local bankPanels = {}
    local panel, row
    columnWidth = self.bankParent:GetWide() / 15 - self.bankParent:GetTall() * 0.01

    for r = 1, 9 do
        bankPanels[ r ] = {}

        row = vgui.Create( "DPanel", self.bankParent )
        row:Dock( TOP )
        row:SetTall( columnWidth )
        row:DockMargin( 0, 0, 0, self.bankParent:GetTall() * 0.01 )
        row:DockPadding( self.bankParent:GetTall() * 0.01, 0, 0, 0 )
        
        function row:Paint() end

        for c = 1, 15 do
            bankPanels[ r ][ c ] = vgui.Create( "InventorySlot", row )
            panel = bankPanels[ r ][ c ]
            panel:Dock( LEFT )
            panel:SetWide( columnWidth )
            panel:DockMargin( 0, 0, self.bankParent:GetTall() * 0.01, 0 )
            panel:SetAlpha( 155 )
            panel.ModelPanel:SetModel( "models/props_interiors/Radiator01a.mdl" )
            panel.ModelPanel:SetDisabled( true )
        end
    end
end

GM:AddHook( "InitPostEntity", "LoadInventory", GM.CreateInventory )

GM:AddHook( "OnReloaded", "RefreshInventory", function()
	if IsValid( GAMEMODE.invParent ) and IsValid( GAMEMODE.bankParent ) then
		GAMEMODE.invParent:Remove()
		GAMEMODE.bankParent:Remove()
		GAMEMODE:CreateInventory()
	else
		GAMEMODE:CreateInventory()
	end
end )