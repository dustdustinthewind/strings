function _init()
  --june colors 🐕
  poke(0x5f2e,1)
  pal({[0]=0,129,2,11,137,130,143,7,8,9,10,138,12,140,136,14},1)

  m = get_mouse_state()
  h = a_heart()

  entities = {
    -- the curtains hide some of the play! we dont need to refresh
    --the whole screen
    ent{} + can_draw(function() rectfill(3, 0, 122, 128, 0) end),
    
    a_heart_string(-1.5, -3, -2, -2),
    a_heart_string(2, -3, 2, -2.2),
    a_heart_string(-4.2, -6, -5, -5),
    a_heart_string(6, -7, 7, -8),
    a_heart_string(-6, -8, -7, -8),
    h,

    curtains(),
  }
end

function _update60()
  m = get_mouse_state()
  beat_heart(entities)
  string_dance(entities)
  pin_string(entities)
end

function _draw()
  draw(entities)
end