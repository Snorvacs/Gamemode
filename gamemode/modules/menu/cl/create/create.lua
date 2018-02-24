GM.MenuPanels = {}

function GM:AddMenuPanel( info, callback )
	self.MenuPanels[ #self.MenuPanels + 1 ] = { info = info, callback = callback }
end