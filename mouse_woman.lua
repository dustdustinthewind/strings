-- mouse womanager
--todo make entity (pos specifically)
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

function mouse_child(i)
  return cmp("follows", {obj = m, interp = i or 0.1,
  move = function(e)
    local _ENV = local_env(e.follows)
    e.pos.x = lerp(e.pos.x, m.x, interp)
    e.pos.y = lerp(e.pos.y, m.y, interp)
  end
  })
end