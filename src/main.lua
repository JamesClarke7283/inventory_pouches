
-- Adds periodic save so when it crashes there are still some items existing.
local save_interval = 60 -- seconds

local function periodic_save()
    for _, player in ipairs(minetest.get_connected_players()) do
        local inv_list = player:get_inventory():get_list("main")
        for _, itemstack in ipairs(inv_list) do
            if itemstack:get_name() == "inventory_pouches:pouch" then
                inventory_pouches.update_inventory(itemstack)
            end
        end
    end
    minetest.after(save_interval, periodic_save)
end

minetest.after(save_interval, periodic_save)


function inventory_pouches.invoke(itemstack, user, pointed_thing)
    local meta = itemstack:get_meta()
    local id = meta:get_string("id")
    if id == "" then
        id = inventory_pouches.get_next_id()
        meta:set_string("id", tostring(id))
        itemstack:set_name("inventory_pouches:pouch")
    end
    local inv = inventory_pouches.create_pouch_inventory(itemstack)

    minetest.show_formspec(user:get_player_name(), "inventory_pouches:pouch" .. id, inventory_pouches.formspec.standard_pouch(id))
    minetest.log("info", "[inventory_pouches] '".. user:get_player_name() .."' Opened pouch inventory with ID: " .. id)
    return itemstack
end

minetest.register_craftitem("inventory_pouches:pouch", {
    description = "Inventory Pouch",
    inventory_image = "inventory_pouches_pouch.png",
    stack_max = 1,
    on_place = inventory_pouches.invoke,
    on_secondary_use = inventory_pouches.invoke
})

if minetest.get_modpath("unifieddyes") then
    minetest.override_item("inventory_pouches:pouch", {
        palette = "unifieddyes_palette_extended.png",
        groups = {ud_param2_colorable = 1},
    })
end


minetest.register_on_player_receive_fields(function(player, formname, fields)
    local id = string.match(formname, "^inventory_pouches:pouch(%d+)")
    if id and fields.quit then
        local inv_list = player:get_inventory():get_list("main")
        for i, itemstack in ipairs(inv_list) do
            if itemstack:get_name() == "inventory_pouches:pouch" then
                local meta = itemstack:get_meta()
                if meta:get_string("id") == id then
                    inventory_pouches.update_inventory(itemstack)
                    minetest.log("verbose", "[inventory_pouches] Updated pouch inventory with ID: " .. id)
                    break
                end
            end
        end
    end
end)

minetest.register_on_shutdown(function()
    for _, player in ipairs(minetest.get_connected_players()) do
        local inv_list = player:get_inventory():get_list("main")
        for i, itemstack in ipairs(inv_list) do
            if itemstack:get_name() == "inventory_pouches:pouch" then
                inventory_pouches.update_inventory(itemstack)
                minetest.log("verbose", "[inventory_pouches] Updated pouch inventory at shutdown for player: " .. player:get_player_name())
            end
        end
    end
end)

minetest.register_on_mods_loaded(function()
inventory_pouches.restore_all_pouches()
end)
