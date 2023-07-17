modname = "inventory_pouches"
modpath = minetest.get_modpath(modname)

dofile(modpath .. "/functions.lua")
dofile(modpath .. "/main.lua")
dofile(modpath .. "/recipes.lua")

functions.restore_all_pouches()
