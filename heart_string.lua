function a_heart_string(x, y, x2, y2)
  local x, y, x2, y2 = x or 0, y or 0, x2 or x, y2 or y

  return ent{}
  + pos(x, y)
  + mouse_child(x, y)
  + is_heart_string(x, y, x2, y2)
  + can_draw(draw_string)
  + pinned_string({1}, function(e)
      printh("hai")
      local _ENV = local_env(e.string)
      local x, y = e.pos.x, e.pos.y
      if (h.heart.on_beat) x, y = x2, y2
      points[1].x, points[1].y = m.x + x, m.y + y
    end)
end

function is_heart_string(x, y, x2, y2)
  str = birth_string(
    x, y,
    3, 1.2)
  str.x2 = x2
  str.y2 = y2
  return cmp("string", str)
end