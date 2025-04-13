function a_heart()
  return ent{} + is_heart()
    + can_draw(function(e)
      spr(e.heart.sprite1, m.x-8, m.y-16, 1, 2)
      spr(e.heart.sprite2,   m.x, m.y-16, 1, 2)
    end)
end

function is_heart()
  return cmp("heart", {
    beat1 = 6.86,
    beat2 = 20,
    beat_speed = 1,
    speed_inc = 0.02,
    sprite1 = 66,
    sprite2 = 67,
    spr_counter = 0,
    clickable = false,
    on_beat = true,
    strings = {},
  })
end

beat_heart = sys({"heart"}, function(e)
  local _ENV = local_env(e.heart)
  clickable = m.click > 0
  spr_counter += beat_speed
  if on_beat then
      if not (spr_counter > beat1) then
          if clickable then 
              sprite1 = 68
          else
              sprite1 = 64
          end
          sprite2 = 65
      else
          on_beat = false
          sfx(2)
          spr_counter = 0
      end
  else
      if not (spr_counter > beat2) then
          if clickable then
              sprite1 = 69
          else
              sprite1 = 66
          end
          sprite2 = 67
      else
          on_beat = true
          sfx(1)
          spr_counter = 0
      end
  end

  beat_speed = mid(0.1, beat_speed + stat(36) * speed_inc, beat1)
end)