

inventory_pouches.dye_color_pairs = {}

-- mcl_signs.mcl_wool_colors only exists in VoxeLibre/MineClone2, not Mineclonia,
-- so the cyan/light-blue/orange/pink/red colors are hardcoded here instead to
-- keep this working across both games. Only mcl_dye + mcl_colors are required.
-- These values are used as a fallback for VoxeLibre; Mineclonia dyes resolve
-- their own color from mcl_dyes (see dye_to_color below).
if minetest.get_modpath("mcl_dye") and minetest.get_modpath("mcl_colors") then
inventory_pouches.dye_color_pairs = {
{"mcl_dye:black",mcl_colors.BLACK},
{"mcl_dye:blue",mcl_colors.BLUE},
{"mcl_dye:brown","#57392b"},
{"mcl_dye:cyan","#169c9c"},
{"mcl_dye:green",mcl_colors.GREEN},
{"mcl_dye:dark_green",mcl_colors.DARK_GREEN},
{"mcl_dye:grey",mcl_colors.GRAY},
{"mcl_dye:dark_grey",mcl_colors.DARK_GRAY},
{"mcl_dye:lightblue","#3ab3da"},
{"mcl_dye:magenta",mcl_colors.LIGHT_PURPLE},
{"mcl_dye:orange","#f9801d"},
{"mcl_dye:pink","#f38baa"},
{"mcl_dye:red","#b02e26"},
{"mcl_dye:violet",mcl_colors.DARK_PURPLE},
{"mcl_dye:white",mcl_colors.WHITE},
{"mcl_dye:yellow",mcl_colors.YELLOW},
}
end

-- Fast lookup of "<mod>:<dye>" -> ColorString (VoxeLibre / Minetest Game).
inventory_pouches.dye_colors = {}
for _, pair in ipairs(inventory_pouches.dye_color_pairs) do
    inventory_pouches.dye_colors[pair[1]] = pair[2]
end

-- Last-resort palette keyed by the color word in a dye's name (e.g. the "red"
-- in "dye:red"), used when no game-specific source is available.
local BASE_COLORS = {
    white = "#ffffff", grey = "#9d9d97", gray = "#9d9d97",
    dark_grey = "#474f52", dark_gray = "#474f52", silver = "#9d9d97",
    black = "#1d1d21", red = "#b02e26", green = "#5e7c16",
    dark_green = "#3a4d10", lime = "#80c71f", blue = "#3c44aa",
    lightblue = "#3ab3da", light_blue = "#3ab3da", cyan = "#169c9c",
    yellow = "#fed83d", brown = "#835432", orange = "#f9801d",
    pink = "#f38baa", magenta = "#c74ebd", purple = "#8932b8",
    violet = "#8932b8",
}

-- Resolve a dye item name to a ColorString across games.
local function dye_to_color(name)
    local def = minetest.registered_items[name]
    -- Mineclonia: every dye carries _color -> mcl_dyes.colors[...].rgb
    if def and mcl_dyes and mcl_dyes.colors and def._color and mcl_dyes.colors[def._color] then
        return mcl_dyes.colors[def._color].rgb
    end
    -- VoxeLibre (mcl_dye:*): explicit map
    if inventory_pouches.dye_colors[name] then
        return inventory_pouches.dye_colors[name]
    end
    -- Fallback (Minetest Game dye:*, etc.): match by the color word in the name
    local suffix = name:match(":([%w_]+)$")
    return suffix and BASE_COLORS[suffix] or nil
end

local POUCH_TEXTURE = "inventory_pouches_pouch.png"

-- Tint a pouch by overriding its per-stack inventory/wield image. The base
-- texture is near-white, so a multiply blend dyes it cleanly while keeping the
-- dark outlines. This is the same approach Mineclonia uses to dye leather armor.
local function set_pouch_color(pouch, color_string)
    local meta = pouch:get_meta()
    local colorized = POUCH_TEXTURE .. "^[multiply:" .. color_string
    meta:set_string("inventory_image", colorized)
    meta:set_string("wield_image", colorized)
end


-- Called both as a craft prediction (output preview) and on the real craft, so
-- the dyed pouch shows up in the result slot and when actually taken.
--
-- IMPORTANT: only act when the actual craft result (itemstack) is a pouch and
-- the grid holds exactly one pouch + one dye. Returning a pouch based purely on
-- the grid contents (ignoring the recipe) makes the craft preview hand out
-- pouches that no recipe backs, so the inputs never get consumed -> infinite
-- pouches. This mirrors how Mineclonia dyes leather armor.
local function craft_colored_pouch(itemstack, player, old_craft_grid, craft_inv)
    if itemstack:get_name() ~= "inventory_pouches:pouch" then
        return
    end

    -- Find exactly one pouch and one dye (dye detected by group, so it works in
    -- MineClone2, VoxeLibre, Mineclonia and Minetest Game alike). Bail on
    -- anything else so we never colorize an invalid/unbacked craft.
    local pouch, dye
    for _, item in ipairs(old_craft_grid) do
        local name = item:get_name()
        if name ~= "" then
            if name == "inventory_pouches:pouch" then
                if pouch then return end
                pouch = item
            elseif minetest.get_item_group(name, "dye") > 0 then
                if dye then return end
                dye = item
            else
                return
            end
        end
    end

    -- Not the "pouch + dye" recipe (e.g. the plain string+chest craft)
    if not (pouch and dye) then
        return
    end

    -- Tint the texture directly (works in every game; no palette needed)
    local color_string = dye_to_color(dye:get_name())
    if not color_string then
        minetest.log("action", "[inventory_pouches] No color mapping for " .. dye:get_name())
        return
    end
    set_pouch_color(pouch, color_string)

    -- The pouch from the craft grid keeps its inventory ID, so the dyed pouch
    -- stays linked to the same contents. The dye is consumed by the recipe.
    return pouch
end

minetest.register_craft_predict(craft_colored_pouch)
minetest.register_on_craft(craft_colored_pouch)



-- A single shapeless "pouch + any dye" recipe. group:dye matches the dye items
-- of every supported game (mcl_dyes:* in Mineclonia, mcl_dye:* in VoxeLibre,
-- dye:* in Minetest Game), so this one recipe covers them all. We deliberately
-- do NOT use unifieddyes' palette craft, even when unifieddyes is installed,
-- because the pouch is dyed via its inventory_image instead.
if minetest.get_modpath("mcl_dyes") or minetest.get_modpath("mcl_dye")
        or minetest.get_modpath("dye") then
    minetest.register_craft({
        type = "shapeless",
        output = "inventory_pouches:pouch",
        recipe = {"inventory_pouches:pouch", "group:dye"},
    })
end
