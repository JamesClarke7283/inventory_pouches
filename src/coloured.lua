


inventory_pouches.dye_color_pairs = {}

if minetest.get_modpath("mcl_dye") and minetest.get_modpath("mcl_colors") then
    inventory_pouches.dye_color_pairs = {
        {"mcl_dye:black",        mcl_colors.BLACK},
        {"mcl_dye:blue",         mcl_colors.BLUE},
        {"mcl_dye:brown",        "#57392b"},
        {"mcl_dye:cyan",         mcl_colors.CYAN},
        {"mcl_dye:green",        mcl_colors.GREEN},
        {"mcl_dye:dark_green",   mcl_colors.DARK_GREEN},
        {"mcl_dye:grey",         mcl_colors.GRAY},
        {"mcl_dye:dark_grey",    mcl_colors.DARK_GRAY},
        {"mcl_dye:lightblue",    mcl_colors.LIGHT_BLUE},
        {"mcl_dye:magenta",      mcl_colors.LIGHT_PURPLE},
        {"mcl_dye:orange",       mcl_colors.ORANGE},
        {"mcl_dye:pink",         mcl_colors.PINK},
        {"mcl_dye:red",          mcl_colors.RED},
        {"mcl_dye:violet",       mcl_colors.DARK_PURPLE},
        {"mcl_dye:white",        mcl_colors.WHITE},
        {"mcl_dye:yellow",       mcl_colors.YELLOW},
    }
end


-- This function is called after the pouch is crafted with a dye.
local function craft_colored_pouch(itemstack, player, old_craft_grid, craft_inv)
    local pouch, dye, dye_stack_index

    -- Find the pouch and dye in the crafting grid
    for i, item in ipairs(old_craft_grid) do
        minetest.log("action", "Searching craft grid data: Index: "..i.." Data: "..dump(item))
        if item:get_name() == "inventory_pouches:pouch" then
            minetest.log("action","Found inventory pouch")
            pouch = item
        elseif string.find(item:get_name(), "^mcl_dye:") or string.find(item:get_name(), "^dye:") then
            minetest.log("action", "Found Dye")
            dye = item
            dye_stack_index = i
        end
    end

    -- If a pouch and dye are found
    if pouch and dye then
        local meta = pouch:get_meta()
        local id = meta:get_string("id")
        minetest.log("action","ID found for pouch: "..id)

        -- Extract dye name from item name
        local dye_name_match = dye:get_name():match(":([%w_]+)$")
        if not dye_name_match then
            minetest.log("error", "Dye name pattern match failed for dye: " .. dye:get_name())
            return itemstack
        end

        -- Handle Unified Dyes
        if minetest.get_modpath("unifieddyes") then
            local color_idx = unifieddyes.getpaletteidx("dye:" .. dye_name_match, "extended")
            meta:set_int("palette_index", color_idx)

        -- Handle Minecraft-like dyes
        elseif minetest.get_modpath("mcl_dye") then
            for _, dye_entry in ipairs(inventory_pouches.dye_color_pairs) do
                local entry_dye_name, color_string = unpack(dye_entry)
                if dye_name_match == entry_dye_name:match(":(%w+)$") then
                    meta:set_string("color", color_string)
                    break
                end
            end
        end

        -- Ensure the ID is maintained
        meta:set_string("id", id)
        minetest.log("action","ID maintained for inventory pouch ".. id)

        -- Remove the used dye from the crafting grid
        if dye:get_count() > 1 then
            dye:take_item()
            craft_inv:set_stack("craft", dye_stack_index, dye)
        else
            craft_inv:set_stack("craft", dye_stack_index, ItemStack(nil))
        end

        -- Return the modified pouch preserving the ID
        return pouch
    end

    -- If no pouch or no dye, return the original itemstack
    minetest.log("action", "Returning original itemstack")
    return itemstack
end

minetest.register_on_craft(craft_colored_pouch)



-- Register crafting recipes for colored pouches
if minetest.get_modpath("mcl_dye") then
    for _, entry in ipairs(inventory_pouches.dye_color_pairs) do
        local dye_name, _ = unpack(entry)
        craft_def = {
            type = "shapeless",
            output = "inventory_pouches:pouch",
            recipe = {"inventory_pouches:pouch", dye_name},
            replacements = {{dye_name, dye_name}}
        }
        if minetest.get_modpath("unifieddyes") then
          -- Change properties of craftitem
        end
      minetest.register_craft(craft_def)
    end
end

if minetest.get_modpath("unifieddyes") then
    unifieddyes.register_color_craft({
        output = "inventory_pouches:pouch",
        palette = "extended",
        neutral_node = "inventory_pouches:pouch",
        recipe = {
            {"", "NEUTRAL_NODE", ""},
            {"", "MAIN_DYE", ""},
            {"", "", ""},
        },
    })
end
