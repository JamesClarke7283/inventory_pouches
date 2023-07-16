local functions = dofile(modpath .. "/functions.lua")

local has_default_mod = minetest.get_modpath("default")
local has_mcl_core_mod = minetest.get_modpath("mcl_core")

if has_default_mod then
    minetest.register_craft({
        output = "inventory_pouches:pouch",
        recipe = {
            {"default:string", "default:string", "default:string"},
            {"default:string", "default:chest", "default:string"},
            {"default:string", "default:string", "default:string"},
        }
    })
elseif has_mcl_core_mod then
    minetest.register_craft({
        output = "inventory_pouches:pouch",
        recipe = {
            {"mcl_core:string", "mcl_core:string", "mcl_core:string"},
            {"mcl_core:string", "mcl_chests:chest", "mcl_core:string"},
            {"mcl_core:string", "mcl_core:string", "mcl_core:string"},
        }
    })
end
