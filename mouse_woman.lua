-- mouse womanager
poke(24365, 1)

function get_mouse_state()
  return {x = stat(32), y = stat(33), click = stat(34), scroll = stat(36)}
end

function mouse_child(x, y)
  return cmp("mouse_child", {x = x, y = y})
end

follow_mouse_mom = sys({"mouse_child", "pos"}, function(e)
  local _ENV = local_env(e)
  pos.x, pos.y = m.x + mouse_child.x, m.y + mouse_child.y
end)