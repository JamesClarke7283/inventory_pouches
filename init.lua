-- You'll need to replace `<modname>` with the name of your mod
modname = "inventory_pouches"
modpath = minetest.get_modpath(modname)

dofile(modpath .. "/functions.lua")
dofile(modpath .. "/main.lua")
dofile(modpath .. "/recipes.lua")
