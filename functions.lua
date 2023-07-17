functions = {}

inventory_size = 27
local inventories = {}

local function inventory_to_table(inv)
    minetest.log("action", "[inventory_pouches] Entering function inventory_to_table")
    local inv_table = {}
    for i, stack in ipairs(inv:get_list("main")) do
        local stack_table = stack:to_table()
        if stack_table then  -- Only add to inv_table if stack_table is not nil
            inv_table[i] = stack_table
            minetest.log("action", "[inventory_pouches] Added stack to table: " .. minetest.serialize(inv_table[i]))
        end
    end
    return inv_table
end

local function table_to_inventory(inv_table, inv)
    for i, stack_table in ipairs(inv_table) do
        inv:set_stack("main", i, ItemStack(stack_table))
        minetest.log("action", "[inventory_pouches] Added stack to inventory: " .. minetest.serialize(stack_table))
    end
end

function functions.get_next_id()
    local highest_id = tonumber(storage:get_string("highest_id")) or 0
    highest_id = highest_id + 1
    storage:set_string("highest_id", tostring(highest_id))
    return highest_id
end

function functions.update_inventory(itemstack)
    local meta = itemstack:get_meta()
    local id = meta:get_string("id")
    local inv = inventories[id]
    if inv then
        local inv_table = inventory_to_table(inv)
        local inv_string = minetest.serialize(inv_table)
        minetest.log("action", "[inventory_pouches] Updated inventory string: " .. inv_string .. " for pouch with ID: " .. id)
        meta:set_string("inventory", inv_string)
        storage:set_string("pouch_" .. id, inv_string)
    end
    minetest.log("action", "[inventory_pouches] Updated inventory for pouch with ID: " .. id)
end

function functions.restore_inventory(itemstack, inv)
    local id = itemstack:get_meta():get_string("id")
    local inv_table_string = storage:get_string("pouch_" .. id)
    minetest.log("action", "[inventory_pouches] Restoring inventory string: " .. inv_table_string .. " for pouch with ID: " .. id)
    if inv_table_string ~= "" then
        local inv_table = minetest.deserialize(inv_table_string)
        table_to_inventory(inv_table, inv)
    end
end

function functions.create_pouch_inventory(itemstack)
    local meta = itemstack:get_meta()
    local id = meta:get_string("id")
    local inv = inventories[id]
    if not inv then
        inv = minetest.create_detached_inventory("pouch_inventory_" .. id, {
            on_put = function(inv)
                functions.update_inventory(itemstack)
            end,
            on_take = function(inv)
                functions.update_inventory(itemstack)
            end
        })
        inv:set_size("main", inventory_size)  -- Adjusted inventory size here
        inventories[id] = inv
        functions.restore_inventory(itemstack, inv)
        functions.update_inventory(itemstack)
        minetest.log("action", "[inventory_pouches] Created new pouch inventory with ID: " .. id)
    else
        minetest.log("action", "[inventory_pouches] Inventory with ID: " .. id .. " already exists.")
    end
    return inv
end


function functions.restore_all_pouches()
    local highest_id = tonumber(storage:get_string("highest_id")) or 0
    for id = 1, highest_id do
        local inv_table_string = storage:get_string("pouch_" .. id)
        if inv_table_string ~= "" then
            local inv = minetest.create_detached_inventory("pouch_inventory_" .. id, {
                on_put = function(inv)
                    local itemstack = ItemStack("inventory_pouches:pouch")
                    itemstack:get_meta():set_string("id", tostring(id))
                    functions.update_inventory(itemstack)
                end,
                on_take = function(inv)
                    local itemstack = ItemStack("inventory_pouches:pouch")
                    itemstack:get_meta():set_string("id", tostring(id))
                    functions.update_inventory(itemstack)
                end
            })
            inv:set_size("main", inventory_size)  -- Adjusted inventory size here
            inventories[id] = inv
            local inv_table = minetest.deserialize(inv_table_string)
            table_to_inventory(inv_table, inv)
            minetest.log("action", "[inventory_pouches] Restored pouch inventory with ID: " .. id)
        end
    end
end

