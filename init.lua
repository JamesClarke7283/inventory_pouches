inventory_pouches = {}

inventory_pouches.modname = minetest.get_current_modname()
inventory_pouches.modpath = minetest.get_modpath(inventory_pouches.modname)
inventory_pouches.storage = minetest.get_mod_storage()
inventory_pouches.src_dir = "/src/"

dofile(inventory_pouches.modpath .. inventory_pouches.src_dir .. "functions.lua")
dofile(inventory_pouches.modpath .. inventory_pouches.src_dir .. "formspecs.lua")
dofile(inventory_pouches.modpath .. inventory_pouches.src_dir .. "main.lua")
dofile(inventory_pouches.modpath .. inventory_pouches.src_dir .. "recipes.lua")

inventory_pouches.restore_all_pouches()
