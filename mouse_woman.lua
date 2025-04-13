-- mouse womanager
poke(24365, 1)

function get_mouse_state()
  local px, py = 0, 0
  if (m) px, py = m.x, m.y
  local x, y, click, scroll = stat(32), stat(33), stat(34), stat(36)
  return {
    px, py = px, py,
    delta = {x = x - px, y = y - py},
    x = x,
    y = y,
    pos = {x = x, y = y},
    click = click,
    scroll = scroll,
}
end

function mouse_child(x, y)
  return cmp("mouse_child", {x = x, y = y})
end

follow_mouse_mom = sys({"mouse_child", "pos"}, function(e)
  local _ENV = local_env(e)
  pos.x, pos.y = m.x + mouse_child.x, m.y + mouse_child.y
end)