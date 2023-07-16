local bag_size = 27

local function inventory_to_table(inv, listname)
    local list = inv:get_list(listname)
    local table_list = {}
    for i, item in ipairs(list) do
        table_list[i] = item:to_string()
    end
    return table_list
end

local function table_to_inventory(inv, listname, table_list)
    local list = {}
    for i, item_string in ipairs(table_list) do
        list[i] = ItemStack(item_string)
    end
    inv:set_list(listname, list)
end

local function update_inventory(player, itemstack)
    local pname = player:get_player_name()
    local inv = minetest.get_inventory({type = "detached", name = "bag_inventory_" .. pname})
    if inv then
        local meta = player:get_meta()
        local items = inventory_to_table(inv, "main")
        meta:set_string("inventory_bags:items", minetest.serialize(items))
    end
end

local function restore_inventory(player, itemstack)
    local pname = player:get_player_name()
    local inv = minetest.get_inventory({type = "detached", name = "bag_inventory_" .. pname})
    if inv then
        local meta = player:get_meta()
        local items_str = meta:get_string("inventory_bags:items")
        local items = minetest.deserialize(items_str)
        if items then
            table_to_inventory(inv, "main", items)
        end
    end
end

minetest.register_craftitem("inventory_bags:bag", {
    description = "Inventory Bag",
    inventory_image = "inventory_bag.png",
    stack_max = 1,
    on_use = function(itemstack, user, pointed_thing)
        local pname = user:get_player_name()
        local inv = minetest.create_detached_inventory("bag_inventory_" .. pname, {
            allow_put = function(inv, listname, index, stack, player)
                return stack:get_count()
            end,
            allow_take = function(inv, listname, index, stack, player)
                return stack:get_count()
            end,
        })
        inv:set_size("main", bag_size)

        restore_inventory(user, itemstack)

        local formspec = "size[9,8.5]" ..
            "label[0,0.1;" .. minetest.formspec_escape(minetest.colorize("#313131", "Inventory Bag")) .. "]" ..
            "listcolors[#AAAAAA;#888888;#FFFFFF]" ..
            "list[detached:bag_inventory_" .. pname .. ";main;0,0.5;9,3;]" ..
            "list[current_player;main;0,4.0;9,3;9]" ..
            "list[current_player;main;0,7.74;9,1;]" ..
            "listring[detached:bag_inventory_" .. pname .. ";main]" ..
            "listring[current_player;main]"

        minetest.show_formspec(pname, "inventory_bags:bag", formspec)

        return itemstack
    end,
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname == "inventory_bags:bag" then
        if fields.quit then
            update_inventory(player)
        end
    end
end)

-- Conditional crafting recipe based on mod dependencies
local has_default_mod = minetest.get_modpath("default")
local has_mcl_core_mod = minetest.get_modpath("mcl_core")

if has_default_mod then
    minetest.register_craft({
        output = "inventory_bags:bag",
        recipe = {
            {"default:string", "default:string", "default:string"},
            {"default:string", "default:chest", "default:string"},
            {"default:string", "default:string", "default:string"},
        }
    })
elseif has_mcl_core_mod then
    minetest.register_craft({
        output = "inventory_bags:bag",
        recipe = {
            {"mcl_mobitems:string", "mcl_mobitems:string", "mcl_mobitems:string"},
            {"mcl_mobitems:string", "mcl_chests:chest", "mcl_mobitems:string"},
            {"mcl_mobitems:string", "mcl_mobitems:string", "mcl_mobitems:string"},
        }
    })
end

