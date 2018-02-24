GmJobSkill = GM.Runtime.oop.create( "skill", false )
GM.JobSkills = {}

include( "sh/levels/values.lua" )

if SERVER then
	include( "sv/save/sql.lua" )
	include( "sh/creation/add.lua" )
	include( "sv/net/send.lua" )
else
	include( "cl/menu/panel.lua" )
	include( "sh/creation/add.lua" )
	include( "cl/net/receive.lua" )
end