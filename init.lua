inventory_pouches = {}

inventory_pouches.modname = minetest.get_current_modname()
inventory_pouches.modpath = minetest.get_modpath(inventory_pouches.modname)
inventory_pouches.storage = minetest.get_mod_storage()
inventory_pouches.src_dir = "/src/"

inventory_pouches.has_default = minetest.get_modpath("default")
inventory_pouches.has_mcl_mobitems = minetest.get_modpath("mcl_mobitems")
inventory_pouches.has_mcl_chests = minetest.get_modpath("mcl_chests")
inventory_pouches.has_mcl_formspec = minetest.get_modpath("mcl_formspec")

dofile(inventory_pouches.modpath .. inventory_pouches.src_dir .. "functions.lua")
dofile(inventory_pouches.modpath .. inventory_pouches.src_dir .. "formspecs.lua")
dofile(inventory_pouches.modpath .. inventory_pouches.src_dir .. "recipes.lua")
dofile(inventory_pouches.modpath .. inventory_pouches.src_dir .. "main.lua")

inventory_pouches.restore_all_pouches()
