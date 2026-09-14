-- whistle.lua

local S = core.get_translator(core.get_current_modname())
local modpath = core.get_modpath(core.get_current_modname())

local whistle_sounds = {
  'jc_party_whistle_01',
  'jc_party_whistle_02',
  'jc_party_whistle_03',
  'jc_party_whistle_04',
  'jc_party_whistle_05',
  'jc_party_whistle_06',
  'jc_party_whistle_07',
}

core.register_tool("jc_party:whistle", {
  description = S("Whistle"),
  inventory_image = "jc_party_whistle.png",
  wield_image     = "jc_party_whistle.png^[transformR190",
  wield_scale     = {x = 0.6, y = 0.6, z = 0.6},
  stack_max = 1,

  on_use = function(itemstack, user)
    if not user then
      return itemstack
    end

    jc_party.alert_jc_special_monsters(user)

    jc_party.play_sound_for_nearby_players(user, whistle_sounds[math.random(#whistle_sounds)], 32, 1.0 )

    return itemstack
  end,
})

core.register_craft({
  output = "jc_party:whistle",
  type = "shapeless",
  recipe = {
    "default:steel_ingot",
    "default:steel_ingot",
    "default:coal_lump",
  }
})
