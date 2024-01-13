inventory_pouches.formspec = {}

function inventory_pouches.formspec.standard_pouch(id)
    local formspec = {}
    local inv_size = inventory_pouches.inventory_size
    local cols = inventory_pouches.has_mcl_formspec and 9 or 8 -- 9 for mineclone2, 8 for minetest_game
    local rows = math.ceil(inv_size / cols)
    local player_inv_cols = inventory_pouches.has_mcl_formspec and 9 or 8
    local hotbar_start = inventory_pouches.has_mcl_formspec and rows * 1.5 or rows + 3.74

    local player_inv_cols = cols
    local pouch_inv_height = rows * 1.1 -- Assuming each row is approximately 1 unit high, with a little extra space
    local player_inv_start = pouch_inv_height + 0.75 -- Increase the space between the pouch inventory and player inventory
    local hotbar_start = player_inv_start + 3 * 1.1 -- Assuming each row is approximately 1 unit high, with a little extra space
    local formspec_height = hotbar_start + 1.1 -- Height of hotbar, assuming it's 1 unit high
    local formspec_width = cols * 1.15 -- Increase if you need more space on the sides

    -- Adjust the horizontal padding for the pouch inventory
    local pouch_inv_x = 0.375

    -- Adjust the horizontal padding for the player inventory and hotbar to align with the pouch inventory
    local player_inv_x = pouch_inv_x



    if inventory_pouches.has_mcl_formspec then
        formspec = {
            "formspec_version[4]",
            "size[11.75,10.5]",  -- Adjusted size for mineclone2
            "label[0.375,0.375;" .. minetest.formspec_escape(minetest.colorize("#313131", "Inventory Pouch")) .. "]",
            mcl_formspec.get_itemslot_bg_v4(0.375, 1, cols, rows),
            "list[detached:pouch_inventory_" .. id .. ";main;0.375,1;"..cols..","..rows..";]",
            mcl_formspec.get_itemslot_bg_v4(0.375, hotbar_start, player_inv_cols, 3),
            "list[current_player;main;0.375,"..hotbar_start..";"..player_inv_cols..",3;9]",
            mcl_formspec.get_itemslot_bg_v4(0.375, hotbar_start + 3.24, player_inv_cols, 1),
            "list[current_player;main;0.375,"..(hotbar_start + 3.24)..";"..player_inv_cols..",1;]",
            "listring[detached:pouch_inventory_" .. id .. ";main]",
            "listring[current_player;main]",
        }
    else  -- minetest_game formspec
      formspec = {
            "size[" .. formspec_width .. "," .. formspec_height .. "]",
            "label[0.375,0.375;" .. minetest.formspec_escape(minetest.colorize("#313131", "Inventory Pouch")) .. "]",
            "listcolors[#AAAAAA;#888888;#FFFFFF]",
"list[detached:pouch_inventory_" .. id .. ";main;" .. pouch_inv_x .. ",1;" .. cols .. "," .. rows .. ";]",
"list[current_player;main;" .. player_inv_x .. "," .. player_inv_start .. ";" .. player_inv_cols .. ",3;9]",
"list[current_player;main;" .. player_inv_x .. "," .. hotbar_start .. ";" .. player_inv_cols .. ",1;0]",
"listring[detached:pouch_inventory_" .. id .. ";main]",
"listring[current_player;main]",
}
    end
    return table.concat(formspec)
end
