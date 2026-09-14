local S = core.get_translator(core.get_current_modname())
local modpath = core.get_modpath(core.get_current_modname())

jc_party = {}

--------------------------------------------------------
-- SOUND SETTINGS
--------------------------------------------------------
function jc_party.play_sound(player, sound, parameters)
  if not player then
    return
  end

  if player:get_meta():get_string("jc_party_sounds") == "off" then
    return
  end

  core.sound_play(sound, parameters)
end

function jc_party.play_sound_for_nearby_players(player, sound, max_hear_distance, gain)
  if not player then
    return
  end

  local sound_pos = player:get_pos()

  if not sound_pos then
    return
  end

  max_hear_distance = max_hear_distance or 32
  gain = gain or 1.0

  local max_distance_squared = max_hear_distance * max_hear_distance

  for _, listener in ipairs(core.get_connected_players()) do
    local meta = listener:get_meta()
    local sound_setting = meta:get_string("jc_party_sounds")

    if sound_setting == "" then
      meta:set_string("jc_party_sounds", "on")
      sound_setting = "on"
    end

    if sound_setting ~= "off" then
      local listener_pos = listener:get_pos()

      if listener_pos then
        local dx = sound_pos.x - listener_pos.x
        local dy = sound_pos.y - listener_pos.y
        local dz = sound_pos.z - listener_pos.z

        if (dx * dx + dy * dy + dz * dz) <= max_distance_squared then
          core.sound_play(sound, {
            to_player = listener:get_player_name(),
            gain = gain,
          })
        end
      end
    end
  end
end

dofile(modpath .. "/monster_alert.lua")
dofile(modpath .. "/party_horn.lua")
dofile(modpath .. "/didgeridoo.lua")
dofile(modpath .. "/whistle.lua")
dofile(modpath .. "/pots_and_pans.lua")
