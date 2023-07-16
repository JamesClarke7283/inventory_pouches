local functions = dofile(modpath .. "/functions.lua")

minetest.register_craftitem("inventory_pouches:pouch", {
    description = "Inventory Pouch",
    inventory_image = "inventory_pouch.png",
    stack_max = 1,
    on_use = function(itemstack, user, pointed_thing)
        local pname = user:get_player_name()
        local inv = minetest.create_detached_inventory("pouch_inventory_" .. pname, {
            allow_put = function(inv, listname, index, stack, player)
                return stack:get_count()
            end,
            allow_take = function(inv, listname, index, stack, player)
                return stack:get_count()
            end,
        })
        inv:set_size("main", functions.pouch_size)

        functions.restore_inventory(user, itemstack)

        local formspec = "size[9,8.5]" ..
            "label[0,0.1;" .. minetest.formspec_escape(minetest.colorize("#313131", "Inventory pouch")) .. "]" ..
            "listcolors[#AAAAAA;#888888;#FFFFFF]" ..
            "list[detached:pouch_inventory_" .. pname .. ";main;0,0.5;9,3;]" ..
            "list[current_player;main;0,4.0;9,3;9]" ..
            "list[current_player;main;0,7.74;9,1;]" ..
            "listring[detached:pouch_inventory_" .. pname .. ";main]" ..
            "listring[current_player;main]"

        minetest.show_formspec(pname, "inventory_pouches:pouch", formspec)

        return itemstack
    end,
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname == "inventory_pouches:pouch" then
        if fields.quit then
            functions.update_inventory(player)
        end
    end
end)
