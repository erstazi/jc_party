-- pots_pans.lua

local S = core.get_translator(core.get_current_modname())

local POTS_PANS_COOLDOWN = 0.25 -- seconds

local last_use = {}

local pots_pans_sounds = {
  "jc_party_pots_pans_01",
  "jc_party_pots_pans_02",
  "jc_party_pots_pans_03",
  "jc_party_pots_pans_04",
  "jc_party_pots_pans_05",
}

--------------------------------------------------------
-- CRAFTING
--------------------------------------------------------

-- Farming skillet + pot -> Pots and Pans
core.register_craft({
  type = "shapeless",
  output = "jc_party:pots_pans",
  recipe = {
    "farming:skillet",
    "farming:pot",
  }
})

-- Pots and Pans -> skillet + pot
core.register_craft({
  type = "shapeless",
  output = "farming:skillet",
  recipe = {
    "jc_party:pots_pans",
  },
  replacements = {
    {"jc_party:pots_pans", "farming:pot"},
  }
})

--------------------------------------------------------
-- TOOL
--------------------------------------------------------

core.register_tool("jc_party:pots_pans", {
  description = S("Pots and Pans"),
  inventory_image = "jc_party_pots_and_pans.png",
  wield_image     = "jc_party_pots_and_pans.png^[transformR260",
  wield_scale     = {x = 1.2, y = 1.2, z = 1.2},
  stack_max = 1,

  on_use = function(itemstack, user)
    if not user then
      return itemstack
    end

    local name = user:get_player_name()
    local now = core.get_us_time()

    if last_use[name]
        and (now - last_use[name]) < (POTS_PANS_COOLDOWN * 1000000) then
      return itemstack
    end

    last_use[name] = now

    jc_party.alert_jc_special_monsters(user)

    core.sound_play(
      pots_pans_sounds[math.random(#pots_pans_sounds)],
      {
        object = user,
        gain = 1.0,
        max_hear_distance = 18,
      }
    )

    return itemstack
  end,

  on_place = function(itemstack, user, pointed_thing)
    if not user then
      return itemstack
    end

    -- Let nodes such as item frames and pedestals handle the click.
    if pointed_thing and pointed_thing.type == "node" then
      local node = core.get_node(pointed_thing.under)
      local def = core.registered_nodes[node.name]

      if def and def.on_rightclick then
        return def.on_rightclick(
          pointed_thing.under,
          node,
          user,
          itemstack,
          pointed_thing
        )
      end
    end

    jc_party.alert_jc_special_monsters(user)

    core.sound_play("jc_party_pots_pans_thud", {
      object = user,
      gain = 1.0,
      max_hear_distance = 8,
    })

    return itemstack
  end,
})