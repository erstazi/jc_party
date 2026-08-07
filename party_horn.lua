-- party_horn.lua

local S = core.get_translator(core.get_current_modname())
local modpath = core.get_modpath(core.get_current_modname())

local HORN_COOLDOWN = 0.25      -- seconds
local TIRED_COOLDOWN = 1.00     -- seconds
local HORN_BEFORE_TIRED = 20    -- blasts before getting tired
local TIRED_BLASTS = 5          -- number of tired sounds
local RECOVERY_TIME = 30        -- seconds without using horn resets stamina

local last_use = {}
local last_tired_use = {}
local horn_count = {}
local tired_left = {}

core.register_craft({
  output = "jc_party:party_horn",
  recipe = {
    {"wool:red"},
    {"default:paper"},
    {"default:paper"},
  }
})

local horn_sounds = {
  'jc_party_horn_01',
  'jc_party_horn_02',
  'jc_party_horn_03',
  'jc_party_horn_04',
  'jc_party_horn_05',
  'jc_party_horn_06',
  'jc_party_horn_07',
  'jc_party_horn_08',
}

local tired_horn_sounds = {
  'jc_party_horn_09',
}

core.register_tool("jc_party:party_horn", {
  description = S("Party Horn"),
  inventory_image = "jc_party_horn.png",
  stack_max = 1,

  on_use = function(itemstack, user)

    if not user then
      return itemstack
    end

    local name = user:get_player_name()
    local now = core.get_us_time()

    -- If enough time has passed, the player catches their breath.
    if last_use[name] and (now - last_use[name]) > (RECOVERY_TIME * 1000000) then
      horn_count[name] = 0
      tired_left[name] = 0
    end

    -- Cooldown
    if last_use[name] and (now - last_use[name]) < (HORN_COOLDOWN * 1000000) then
      return itemstack
    end

    -- Tired Cooldown
    if last_tired_use[name] and (now - last_tired_use[name]) < (TIRED_COOLDOWN * 1000000) then
      return itemstack
    end

    last_use[name] = now

    horn_count[name] = horn_count[name] or 0
    tired_left[name] = tired_left[name] or 0

    local sound

    if tired_left[name] > 0 then
      last_tired_use[name] = now

      sound = tired_horn_sounds[math.random(#tired_horn_sounds)]
      tired_left[name] = tired_left[name] - 1

      if tired_left[name] == 0 then
        horn_count[name] = 0
      end
    else
      last_use[name] = now

      horn_count[name] = horn_count[name] + 1

      if horn_count[name] >= HORN_BEFORE_TIRED then
        tired_left[name] = TIRED_BLASTS
      end

      sound = horn_sounds[math.random(#horn_sounds)]
    end

    core.sound_play(sound, {
      object = user,
      gain = 1.0,
      max_hear_distance = 32,
    })

    return itemstack
  end,
})