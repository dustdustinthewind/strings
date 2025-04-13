function a_heart_string(x, y, x2, y2)
  local x, y, x2, y2 = x or 0, y or 0, x2 or x, y2 or y

  local r = ent{}
  + pos(m.x + x, m.y + y)
  + mouse_child()
  + is_heart_string(x, y, x2, y2)
  + can_draw(draw_heart_string)
  + pinned_string(function(e)
      local _ENV = local_env(e.string)
      local ox, oy = x, y
      if (h.heart.on_beat) ox, oy = x2, y2
      points[1].x, points[1].y = e.pos.x + ox, e.pos.y + oy
    end)

  return add(strings, r)
end

function draw_heart_string(e)
  local colors = {}
  colors[8],colors[12],colors[14],colors[13] = 12,8,13,14
  local col = e.string.col
  local clickable = h.heart.clickable
  if(clickable and (col ~= 12 and col ~= 13)) or (not clickable and (col == 12 or col == 13)) then      e.string.col = colors[col]
  end
  
  draw_string(e)
end

function is_heart_string(x, y, x2, y2)
  local str = birth_string(
    m.x+x, m.y+y,
    rnd({3,4}), -- seg #
    rnd({1.23,1.1}), -- seg_len
    0.1111, .94 + rnd(3)/15,
    rnd({8,14})) --gravity friction color
  str.x2 = x2
  str.y2 = y2
  return cmp("string", str)
end