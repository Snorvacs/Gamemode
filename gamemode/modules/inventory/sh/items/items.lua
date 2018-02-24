--[[
    Example Item:

    {
        name = "Bread",
        type = ITEM_FOOD,
        model = "models/badger/bread.mdl",
        ent = "ent_bread",
        callback = function() end
    },

    OR

    {
        name = "Bread",
        type = ITEM_FOOD,
        picture = "materials/bread.png",
        ent = "ent_bread",
        callback = function() end
    },

]]--

GM.Items = {
    {
        name = "Bread",
        type = ITEM_FOOD,
        model = "models/props_interiors/Radiator01a.mdl",
        ent = "prop_physics",
        callback = function( self, ent )
            ent:SetModel( self.model )
        end
    },
}