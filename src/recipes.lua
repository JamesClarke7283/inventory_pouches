if inventory_pouches.has_default then
    minetest.register_craft({
        output = "inventory_pouches:pouch",
        recipe = {
            {"default:string", "default:string", "default:string"},
            {"default:string", "default:chest", "default:string"},
            {"default:string", "default:string", "default:string"},
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
