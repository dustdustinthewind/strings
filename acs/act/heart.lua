function a_heart()
  return heart, a_mouse_simp(0.05)
end

heart = a_costume("heart", {
  beat1 = 34.3,
  beat2 = 100,
  beat_speed = 1,
  speed_inc = 0.05,
  sprite1 = 66,
  --sprite2 = 99,
  spr_counter = 0,
  clickable = false,
  on_beat = true,
  strings = {},
})

draw_heart = a_script(function(_ENV)
  spr(heart.sprite1, pos.x-8, pos.y-16, 1, 2)
  --spr(heart.sprite2,   pos.x, pos.y-16, 1, 2)
end, "mouse_simp", "heart")

update_heart = a_script(function(_ENV)
  local _ENV = local_env(heart)
  clickable = m.click > 0
  spr_counter += beat_speed
  if on_beat then
      if not (spr_counter > beat1) then
          if clickable then 
              sprite1 = 68
          else
              sprite1 = 64
          end
          --sprite2 = 97
      else
          on_beat = false
          sfx(2)
          --[[for i=100, rnd(8)+2 do
            add(entities,
            a_blood_drop(
              e.pos.x - 2 -rnd(4),
              e.pos.y - 2 - rnd(5),
              e.pos.delta.x - rnd(2),
              e.pos.delta.y + rnd(2)-0.5
            ), 2)
          end]]
          spr_counter = 0
      end
  else
      if not (spr_counter > beat2) then
          if clickable then
              sprite1 = 69
          else
              sprite1 = 66
          end
          --sprite2 = 99
      else
          on_beat = true
          sfx(1)
          spr_counter = 0
      end
  end

  beat_speed = mid(0.1, beat_speed + m.scroll * speed_inc, beat1)
end, "pos", "follow", "heart")