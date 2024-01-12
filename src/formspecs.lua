inventory_pouches.formspec = {}

function inventory_pouches.formspec.standard_pouch(id)
  local formspec = {
    "size[9,8.5]",
    "label[0,0.1;" .. minetest.formspec_escape(minetest.colorize("#313131", "Inventory pouch")) .. "]",
    "listcolors[#AAAAAA;#888888;#FFFFFF]",
    "list[detached:pouch_inventory_" .. id .. ";main;0,0.5;9,3;]",
    "list[current_player;main;0,4.0;9,3;9]",
    "list[current_player;main;0,7.74;9,1;]",
    "listring[detached:pouch_inventory_" .. id .. ";main]",
    "listring[current_player;main]"
  }
  return table.concat(formspec)
end
