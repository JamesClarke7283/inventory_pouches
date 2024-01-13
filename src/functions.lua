inventory_pouches.inventories = {}

local function inventory_to_table(inv)
    minetest.log("verbose", "[inventory_pouches] Entering function inventory_to_table")
    local inv_table = {}
    for i, stack in ipairs(inv:get_list("main")) do
        local stack_table = stack:to_table()
        if stack_table then  -- Only add to inv_table if stack_table is not nil
            inv_table[i] = stack_table
            minetest.log("verbose", "[inventory_pouches] Added stack to table: " .. minetest.serialize(inv_table[i]))
        end
    end
    return inv_table
end

local function table_to_inventory(inv_table, inv)
    for i, stack_table in ipairs(inv_table) do
        inv:set_stack("main", i, ItemStack(stack_table))
        minetest.log("verbose", "[inventory_pouches] Added stack to inventory: " .. minetest.serialize(stack_table))
    end
end

function inventory_pouches.get_next_id()
    local highest_id = tonumber(inventory_pouches.storage:get_string("highest_id")) or 0
    highest_id = highest_id + 1
    inventory_pouches.storage:set_string("highest_id", tostring(highest_id))
    return highest_id
end

function inventory_pouches.update_inventory(itemstack)
    local meta = itemstack:get_meta()
    local id = meta:get_string("id")
    local inv = inventory_pouches.inventories[id]
    if inv then
        local inv_table = inventory_to_table(inv)
        local inv_string = minetest.serialize(inv_table)
        minetest.log("verbose", "[inventory_pouches] Updated inventory string: " .. inv_string .. " for pouch with ID: "
        .. id)
        meta:set_string("inventory", inv_string)
        inventory_pouches.storage:set_string("pouch_" .. id, inv_string)
    end
    minetest.log("verbose", "[inventory_pouches] Updated inventory for pouch with ID: " .. id)
end

function inventory_pouches.restore_inventory(itemstack, inv)
    local id = itemstack:get_meta():get_string("id")
    local inv_table_string = inventory_pouches.storage:get_string("pouch_" .. id)
    minetest.log("verbose", "[inventory_pouches] Restoring inventory string: " .. inv_table_string .. " for pouch with ID: " .. id)
    if inv_table_string ~= "" then
        local inv_table = minetest.deserialize(inv_table_string)
        table_to_inventory(inv_table, inv)
    end
end

-- Define a reusable check function
function inventory_pouches.allow_put(inv, listname, index, stack, player)
    -- Get the currently wielded item
    local wielded_item = player:get_wielded_item()
    local wielded_meta = wielded_item:get_meta()
    local wielded_id = wielded_meta:get_string("id")

    -- Check if the item being placed is a pouch and if it matches the ID of the wielded item
    if string.find(stack:get_name(), "^inventory_pouches:") then
        local stack_meta = stack:get_meta()
        local stack_id = stack_meta:get_string("id")
        if wielded_id == stack_id then
            -- Disallow placing the same pouch inside itself
            return 0 -- Disallow the put action
        end
    end
    -- Allow other items to be put in the inventory
    return stack:get_count()
end


function inventory_pouches.create_pouch_inventory(itemstack)
    local meta = itemstack:get_meta()
    local id = meta:get_string("id")
    local inv = inventory_pouches.inventories[id]
    if not inv then
        inv = minetest.create_detached_inventory("pouch_inventory_" .. id, {
            allow_put  = inventory_pouches.allow_put,
            on_put = function(inv)
                inventory_pouches.update_inventory(itemstack)
            end,
            on_take = function(inv)
                inventory_pouches.update_inventory(itemstack)
            end
        })
        inv:set_size("main", inventory_pouches.inventory_size)
        inventory_pouches.inventories[id] = inv
        inventory_pouches.restore_inventory(itemstack, inv)
        inventory_pouches.update_inventory(itemstack)
        minetest.log("info", "[inventory_pouches] Created new pouch inventory with ID: " .. id)
    else
        minetest.log("info", "[inventory_pouches] Inventory with ID: " .. id .. " already exists.")
    end
    return inv
end


function inventory_pouches.restore_all_pouches()
    local highest_id = tonumber(inventory_pouches.storage:get_string("highest_id")) or 0
    for id = 1, highest_id do
        local inv_table_string = inventory_pouches.storage:get_string("pouch_" .. id)
        if inv_table_string ~= "" then
            local inv = minetest.create_detached_inventory("pouch_inventory_" .. id, {
                allow_put = inventory_pouches.allow_put,
                on_put = function(inv)
                    local itemstack = ItemStack("inventory_pouches:pouch")
                    itemstack:get_meta():set_string("id", tostring(id))
                    inventory_pouches.update_inventory(itemstack)
                end,
                on_take = function(inv)
                    local itemstack = ItemStack("inventory_pouches:pouch")
                    itemstack:get_meta():set_string("id", tostring(id))
                    inventory_pouches.update_inventory(itemstack)
                end
            })
            inv:set_size("main", inventory_pouches.inventory_size)  -- Adjusted inventory size here
            inventory_pouches.inventories[id] = inv
            local inv_table = minetest.deserialize(inv_table_string)
            table_to_inventory(inv_table, inv)
            minetest.log("verbose", "[inventory_pouches] Restored pouch inventory with ID: " .. id)
        end
    end
end
