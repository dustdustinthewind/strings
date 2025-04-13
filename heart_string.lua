function a_heart_string(x, y, x2, y2)
  local x, y, x2, y2 = x or 0, y or 0, x2 or x, y2 or y

  return add(strings, ent{}
  + pos(x, y)
  + mouse_child(x, y)
  + is_heart_string(x, y, x2, y2)
  + can_draw(draw_heart_string)
  + pinned_string({1}, function(e)
      local _ENV = local_env(e.string)
      local x, y = e.pos.x, e.pos.y
      if (h.heart.on_beat) x, y = x2, y2
      points[1].x, points[1].y = m.x + x, m.y + y
    end))
end

function draw_heart_string(e)
  if e.pos.x < 0 then
    local colors = {}
    colors[8],colors[12],colors[14],colors[13] = 12,8,13,14
    local col = e.string.col
    local clickable = h.heart.clickable
    if col and (
      (clickable and (col ~= 12 and col ~= 13)) or (not clickable and (col == 12 or col == 13))) then
      e.string.col = colors[col]
    end
  end
  
  draw_string(e)
end

function is_heart_string(x, y, x2, y2)
  str = birth_string(
    m.x+x, m.y+y,
    rnd({3,4}), -- seg #
    rnd({1.23,1.8,1.45})), -- seg_len
    0.1111, .93 + rnd(3)/15, rnd({8,14}) --gravity friction color
  str.x2 = x2
  str.y2 = y2
  return cmp("string", str)
end