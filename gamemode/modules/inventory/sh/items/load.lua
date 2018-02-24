GM.ItemNames = {}
GM.ItemEntities = {}
GM.ItemModels = {}

for _, item in ipairs( GM.Items ) do
    GM.ItemNames[ item.name ] = item
    GM.ItemEntities[ item.ent ] = item
    GM.ItemModels[ item.model ] = item
end