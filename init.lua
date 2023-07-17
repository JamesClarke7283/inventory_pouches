modname = "inventory_pouches"
modpath = minetest.get_modpath(modname)
storage = minetest.get_mod_storage()

dofile(modpath .. "/functions.lua")
dofile(modpath .. "/main.lua")
dofile(modpath .. "/recipes.lua")

functions.restore_all_pouches()
