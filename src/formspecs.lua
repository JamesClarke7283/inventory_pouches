inventory_pouches.formspec = {}

function inventory_pouches.formspec.standard_pouch(id)
    local formspec = {""}
    if inventory_pouches.has_mcl_formspec then
      formspec = {
      "formspec_version[4]",
      "size[11.75,10.5]",  -- Matching the size with the inventory_admins mod

      -- Label for the pouch inventory
      "label[0.375,0.375;" .. minetest.formspec_escape(minetest.colorize("#313131", "Inventory Pouch")) .. "]",

      -- Slot backgrounds for the pouch inventory
      mcl_formspec.get_itemslot_bg_v4(0.375, 1, 9, 3),

      -- Slot list for the pouch inventory
      "list[detached:pouch_inventory_" .. id .. ";main;0.375,1;9,3;]",

      -- Slot backgrounds for the current player's main inventory excluding the hotbar
      mcl_formspec.get_itemslot_bg_v4(0.375, 5, 9, 3),

      -- Slot list for the current player's main inventory excluding the hotbar
      "list[current_player;main;0.375,5;9,3;9]",

      -- Slot background for the current player's hotbar
      mcl_formspec.get_itemslot_bg_v4(0.375, 9, 9, 1),

      -- Slot list for the current player's hotbar
      "list[current_player;main;0.375,9;9,1;]",

      -- Listrings to allow moving items between the pouch inventory and the player's inventory
      "listring[detached:pouch_inventory_" .. id .. ";main]",
      "listring[current_player;main]"
  }





    elseif inventory_pouches.has_default then  -- Corrected 'else if' to 'elseif'
        formspec = {
            "size[9,8.5]",
            "label[0,0.1;" .. minetest.formspec_escape(minetest.colorize("#313131", "Inventory pouch")) .. "]",
            "listcolors[#AAAAAA;#888888;#FFFFFF]",
            "list[detached:pouch_inventory_" .. id .. ";main;0,0.5;9,3;]",
            "list[current_player;main;0,4.0;9,3;9]",
            "list[current_player;main;0,7.74;9,1;]",
            "listring[detached:pouch_inventory_" .. id .. ";main]",
            "listring[current_player;main]"
        }
    end
    return table.concat(formspec)
end
