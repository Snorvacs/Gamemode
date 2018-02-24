local out = false

local function inQuad( fraction, beginning, change )
	return change * ( fraction ^ 2 ) + beginning
end

local InvSlideOut = Derma_Anim( "InventorySlideOut", main, function( pnl, anim, delta, data )
	GAMEMODE.invParent:SetPos( inQuad( delta, 0, ScrW() * -0.4 ), 0 )
end )

local InvSlideIn = Derma_Anim( "InventorySlideIn", main, function( pnl, anim, delta, data )
	GAMEMODE.invParent:SetPos( inQuad( delta, ScrW() * -0.4, ScrW() * 0.4 ), 0 )
end )

local BankSlideOut = Derma_Anim( "BankSlideOut", main, function( pnl, anim, delta, data )
	GAMEMODE.bankParent:SetPos( inQuad( delta, ScrW() - ScrW() * 0.4, ScrW() * 0.4 ), 0 )
end )

local BankSlideIn = Derma_Anim( "BankSlideIn", main, function( pnl, anim, delta, data )
	GAMEMODE.bankParent:SetPos( inQuad( delta, ScrW(), ScrW() * -0.4 ), 0 )
end )

function GM.Inventory()
    if !IsValid( GAMEMODE.invParent ) then return end
    if GAMEMODE.MainMenu:IsVisible() then return end
    if out then
        gui.EnableScreenClicker( false )
        InvSlideOut:Start( 0.2 )
        InvSlideIn:Stop()
        BankSlideOut:Start( 0.2 )
        BankSlideIn:Stop()
    else
        gui.EnableScreenClicker( true )
        InvSlideIn:Start( 0.2 )
        InvSlideOut:Stop()
        BankSlideIn:Start( 0.2 )
        BankSlideOut:Stop()
    end
    out = !out
end

GM:AddHook( "Think", "InventoryAnimations", function()
    if InvSlideIn:Active() then
        InvSlideIn:Run()
        BankSlideIn:Run()
    elseif InvSlideOut:Active() then
        InvSlideOut:Run()
        BankSlideOut:Run()
    end
end )

concommand.Add( "inventory", GM.Inventory )