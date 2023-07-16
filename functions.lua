local pouch_size = 27

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
    local inv = minetest.get_inventory({type = "detached", name = "pouch_inventory_" .. pname})
    if inv then
        local meta = player:get_meta()
        local items = inventory_to_table(inv, "main")
        meta:set_string("inventory_pouches:items", minetest.serialize(items))
    end
end

local function restore_inventory(player, itemstack)
    local pname = player:get_player_name()
    local inv = minetest.get_inventory({type = "detached", name = "pouch_inventory_" .. pname})
    if inv then
        local meta = player:get_meta()
        local items_str = meta:get_string("inventory_pouches:items")
        local items = minetest.deserialize(items_str)
        if items then
            table_to_inventory(inv, "main", items)
        end
    end
end

return {
    inventory_to_table = inventory_to_table,
    table_to_inventory = table_to_inventory,
    update_inventory = update_inventory,
    restore_inventory = restore_inventory,
    pouch_size = pouch_size,
}
