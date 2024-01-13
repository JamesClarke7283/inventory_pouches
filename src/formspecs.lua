inventory_pouches.formspec = {}

function inventory_pouches.formspec.standard_pouch(id)
    local formspec = {}
    local inv_size = inventory_pouches.inventory_size
    local cols = inventory_pouches.has_mcl_formspec and 9 or 8 -- 9 for mineclone2, 8 for minetest_game
    local rows = math.ceil(inv_size / cols)
    local formspec_width = cols * 1.30 -- Width of the formspec
    local formspec_height = rows + 7.5 -- Height of the formspec

    local padding_x = 0.375 -- Horizontal padding for alignment
    local pouch_inv_start_y = 1 -- Starting point of the pouch inventory on the Y-axis
    local gap = 0.75 -- Gap between the pouch and player inventories
    local player_inv_start_y = pouch_inv_start_y + (rows * 1.1) + gap -- Starting point of the player inventory on the Y-axis
    local hotbar_start_y = player_inv_start_y + 3 + gap + 0.20 -- Starting point of the hotbar on the Y-axis

    -- Define the formspec elements for the pouch inventory, player inventory, and hotbar
    local pouch_inv = "list[detached:pouch_inventory_" .. id .. ";main;" .. padding_x .. "," .. pouch_inv_start_y .. ";" .. cols .. "," .. rows .. ";]"
    local player_inv = "list[current_player;main;" .. padding_x .. "," .. player_inv_start_y .. ";" .. cols .. ",3;"..cols.."]"
    local hotbar = "list[current_player;main;" .. padding_x .. "," .. hotbar_start_y .. ";" .. cols .. ",1;0]"

    if inventory_pouches.has_mcl_formspec then
      formspec_height = hotbar_start_y + 1.5 -- Add more space for the hotbar
        formspec_width = cols + 1.5 -- Add more width for MineClone2 styling
        formspec = {
            "formspec_version[4]",
            "size[11.75," .. formspec_height .. "]", -- Adjusted size for MineClone2
            "label[0.375,0.375;" .. minetest.formspec_escape(minetest.colorize("#313131", "Inventory Pouch")) .. "]",
            mcl_formspec.get_itemslot_bg_v4(0.375, 0.75, cols, rows),
            pouch_inv,
            mcl_formspec.get_itemslot_bg_v4(0.375, player_inv_start_y, cols, 3),
            player_inv,
            mcl_formspec.get_itemslot_bg_v4(0.375, hotbar_start_y, cols, 1),
            hotbar,
            "listring[detached:pouch_inventory_" .. id .. ";main]",
            "listring[current_player;main]",
        }
    else  -- minetest_game formspec
      formspec = {
        "formspec_version[3]",
        "size[" .. formspec_width .. "," .. formspec_height .. "]",
        "label[" .. padding_x .. ",0.5;Inventory Pouch]",
        "listcolors[#AAAAAA;#888888;#FFFFFF;#333333;#BBBBBB]",
        pouch_inv,
        player_inv,
        hotbar,
        "listring[detached:pouch_inventory" .. id .. ";main]",
        "listring[current_player;main]",
      }
    end
    return table.concat(formspec)
end
