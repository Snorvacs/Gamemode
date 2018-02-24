include( "sh/items/items.lua" )
include( "sh/items/load.lua" )
include( "sh/items/meta.lua" )

if SERVER then
	include( "sv/items/load.lua" )
else
	include( "cl/panels/gui_modelicon.lua" )
	include( "cl/panels/inventoryslot.lua" )
	include( "cl/menu/panel.lua" )
	include( "cl/menu/open.lua" )
end