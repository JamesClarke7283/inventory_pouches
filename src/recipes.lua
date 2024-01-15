if inventory_pouches.has_default and inventory_pouches.has_farming then
    minetest.register_craft({
        output = "inventory_pouches:pouch",
        recipe = {
            {"farming:string", "farming:string", "farming:string"},
            {"farming:string", "default:chest", "farming:string"},
            {"farming:string", "farming:string", "farming:string"},
        }
    })
elseif inventory_pouches.has_mcl_mobitems and inventory_pouches.has_mcl_chests then
    minetest.register_craft({
        output = "inventory_pouches:pouch",
        recipe = {
            {"mcl_mobitems:string", "mcl_mobitems:string", "mcl_mobitems:string"},
            {"mcl_mobitems:string", "mcl_chests:chest", "mcl_mobitems:string"},
            {"mcl_mobitems:string", "mcl_mobitems:string", "mcl_mobitems:string"},
        }
    })
end
