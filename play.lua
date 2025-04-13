-- "corrupt" memory/sprites by setting random pixels black/random colors
--  fucking with sounds
--  happens over time

function _init()
  --june colors 🐕
  poke(0x5f2e,1)
  pal({[0]=0,129,2,11,137,130,143,7,8,9,10,138,12,140,136,14},1)

  m = get_mouse_state()
  h = a_heart()
  strings = {}
  particles = {}

  -- will be drawn in order
  entities = {
    -- the curtains hide some of the play! we dont need to refresh
    --the whole screen
    ent{} + can_draw(function() rectfill(3, 0, 122, 128, 0) end),
    
    a_heart_string(-1.9, -3.2, -2.5, -2.5),
    --a_heart_string(1.8, -3, 2.8, -2.2),
    a_heart_string(-4.2, -7, -5, -6),
    --a_heart_string(5, -6, 6, -6),
    a_heart_string(-6.4, -9, -7.2, -8.4),
    h,

    curtains(),
  }
end

function _update60()
  m = get_mouse_state()
  beat_heart({h})
  string_dance(strings)
  pin_string(strings)
  partical_update(particles)
end

function _draw()
  draw(entities)
end