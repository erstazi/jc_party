-- monster_alert.lua

local alert_entities = {
  ["mobs_monster:trooper"] = true,
  ["mobs_monster:castle_guard"] = true,
}

function jc_party.alert_jc_special_monsters(player)
  local player_pos = player:get_pos()

  if not player_pos then
    return
  end

  for _, object in ipairs(core.get_objects_inside_radius(player_pos, 40)) do
    local entity = object:get_luaentity()

    if entity and alert_entities[entity.name] then
      local monster_pos = object:get_pos()

      if monster_pos then
        local dx = player_pos.x - monster_pos.x
        local dz = player_pos.z - monster_pos.z

        if dx ~= 0 or dz ~= 0 then
          local yaw = math.atan2(dz, dx) - math.pi / 2

          object:set_yaw(yaw)
        end
      end
    end
  end
end