functions = {}

local inventories = {}
local storage = minetest.get_mod_storage()

local function inventory_to_table(inv)
    local inv_table = {}
    for i, stack in ipairs(inv:get_list("main")) do
        inv_table[i] = stack:to_table()
    end
    return inv_table
end

local function table_to_inventory(inv_table, inv)
    for i, stack_table in ipairs(inv_table) do
        inv:set_stack("main", i, ItemStack(stack_table))
    end
end

function functions.get_next_id()
    local highest_id = tonumber(storage:get_string("highest_id")) or 0
    highest_id = highest_id + 1
    storage:set_string("highest_id", tostring(highest_id))
    return highest_id
end

function functions.update_inventory(itemstack)
    local id = itemstack:get_meta():get_string("id")
    local inv = inventories[id]
    if inv then
        local inv_table = inventory_to_table(inv)
        storage:set_string("pouch_" .. id, minetest.serialize(inv_table))
    end
end

function functions.restore_inventory(itemstack, inv)
    local id = itemstack:get_meta():get_string("id")
    local inv_table_string = storage:get_string("pouch_" .. id)
    if inv_table_string ~= "" then
        local inv_table = minetest.deserialize(inv_table_string)
        table_to_inventory(inv_table, inv)
    end
end

function functions.create_pouch_inventory(itemstack)
    local id = itemstack:get_meta():get_string("id")
    local inv = minetest.create_detached_inventory("pouch_inventory_" .. id, {
        on_put = function(inv)
            functions.update_inventory(itemstack)
        end,
        on_take = function(inv)
            functions.update_inventory(itemstack)
        end
    })
    inv:set_size("main", 16)
    inventories[id] = inv
    functions.restore_inventory(itemstack, inv)
    functions.update_inventory(itemstack)  -- update inventory immediately after restore
    return inv
end
