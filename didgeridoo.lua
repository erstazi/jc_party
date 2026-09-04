-- didgeridoo.lua

local S = core.get_translator(core.get_current_modname())
local modpath = core.get_modpath(core.get_current_modname())

local DIDGERIDOO_COOLDOWN = 1.5 -- seconds

local last_use = {}

local didgeridoo_sounds = {
  "jc_party_didgeridoo1",
  "jc_party_didgeridoo2",
  "jc_party_didgeridoo3",
}

core.register_craft({
  output = "jc_party:didgeridoo",
  recipe = {
    {"group:tree", "", ""},
    {"group:tree", "", ""},
    {"group:tree", "", ""},
  }
})

core.register_tool("jc_party:didgeridoo", {
  description = S("Didgeridoo"),
  inventory_image = "jc_party_didgeridoo.png",
  wield_image = "jc_party_didgeridoo.png",
  wield_scale = {x = 1.5, y = 6.0, z = 1},
  stack_max = 1,
  on_use = function(itemstack, user)
    if not user then
      return itemstack
    end

    local name = user:get_player_name()
    local now = core.get_us_time()

    if last_use[name] and (now - last_use[name]) < (DIDGERIDOO_COOLDOWN * 1000000) then
      return itemstack
    end

    last_use[name] = now

    jc_party.alert_jc_special_monsters(user)

    -- core.sound_play(didgeridoo_sounds[math.random(#didgeridoo_sounds)], {
      -- object = user,
      -- gain = 1.0,
      -- max_hear_distance = 48,
    -- })

    -- jc_party.play_sound(user, didgeridoo_sounds[math.random(#didgeridoo_sounds)], {
      -- object = user,
      -- gain = 1.0,
      -- max_hear_distance = 48,
    -- })
    jc_party.play_sound_for_nearby_players(user, didgeridoo_sounds[math.random(#didgeridoo_sounds)], 48, 1.0)

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

    -- Otherwise, play the didgeridoo thud.
    -- core.sound_play("jc_party_didgeridoo_thud", {
      -- object = user,
      -- gain = 1.0,
      -- max_hear_distance = 8,
    -- })
    -- jc_party.play_sound(user, "jc_party_didgeridoo_thud", {
      -- object = user,
      -- gain = 1.0,
      -- max_hear_distance = 8,
    -- })
    jc_party.play_sound_for_nearby_players(user, "jc_party_didgeridoo_thud", 20, 1.0)

    return itemstack
  end,
})

