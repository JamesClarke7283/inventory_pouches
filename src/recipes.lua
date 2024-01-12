inventory_pouches.has_default = minetest.get_modpath("default")
inventory_pouches.has_mcl = minetest.get_modpath("mcl_core")

if inventory_pouches.has_default then
    minetest.register_craft({
        output = "inventory_pouches:pouch",
        recipe = {
            {"default:string", "default:string", "default:string"},
            {"default:string", "default:chest", "default:string"},
            {"default:string", "default:string", "default:string"},
        }
    })
elseif inventory_pouches.has_mcl then
    minetest.register_craft({
        output = "inventory_pouches:pouch",
        recipe = {
            {"mcl_mobitems:string", "mcl_mobitems:string", "mcl_mobitems:string"},
            {"mcl_mobitems:string", "mcl_chests:chest", "mcl_mobitems:string"},
            {"mcl_mobitems:string", "mcl_mobitems:string", "mcl_mobitems:string"},
        }
    })
end
