local PANEL = {}

AccessorFunc( PANEL, "m_sModel", "Model", FORCE_STRING )
AccessorFunc( PANEL, "m_sName", "Name", FORCE_STRING )
AccessorFunc( PANEL, "m_nID", "ID", FORCE_NUMBER )
AccessorFunc( PANEL, "m_nAlpha", "Alpha", FORCE_NUMBER )

function PANEL:Init()
    self:SetAlpha( 255 )
    self.FollowMouse = false

    local padding = self:GetTall() * 0.1
    self.padding = padding
    self:DockPadding( padding, padding, padding, padding )

    self.ModelPanel = vgui.Create( "ModelIcon", self )
    self.ModelPanel:Dock( FILL )
    self.ModelPanel:InvalidateParent()

    function self.ModelPanel:DragMousePress( code )
        if self:GetDisabled() then return end
        if code != MOUSE_LEFT then return end
        self.Parent = self:GetParent()

        self.Parent.FollowMouse = true

        local x, y, w, h = self:GetBounds()
        self:SetParent()
        self:Dock( NODOCK )
        self:SetSize( w, h )
    end

    function self.ModelPanel:DragMouseRelease( code )
        if self:GetDisabled() then return end
        if code != MOUSE_LEFT then return end
        if !self.Parent.FollowMouse then return end

        self.Parent.FollowMouse = false

        self:SetParent( self.Parent )
        self:Dock( FILL )
    end
end

function PANEL:SetItem( item )
    self.RawItem = item
    self:SetModel( item.model )
    self:SetName( item.name )
    self:SetID( item.id )
end

function PANEL:GetItem()
    return self.RawItem
end

function PANEL:Think()
    if self.FollowMouse then
        self.ModelPanel:SetPos( gui.MousePos() )
        self.ModelPanel:MoveToFront()
    end
end

function PANEL:Paint( w, h )
    surface.SetDrawColor( Color( 32, 32, 32, self:GetAlpha() ) )
    surface.DrawRect( 0, 0, w, h )

    surface.SetDrawColor( Color( 26, 26, 26, self:GetAlpha() ) )
    surface.DrawRect( self.padding, self.padding, w - self.padding * 2 + 1, h - self.padding * 2 + 1 )
end

vgui.Register( "InventorySlot", PANEL, "EditablePanel" )