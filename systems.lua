update_ppos = sys({"pos"}, function(e)
  local _ENV = local_env(e.pos)
  delta = {x = x-px, y = y-py}
  px, py = x, y
end)

draw = sys({"draw"}, function(e)
  e:draw()
end)

move_followers = sys({"follows", "pos"}, function(e)
  e.follows.move(e)
  --[[local _ENV = local_env(e.follows)
  printh(obj.pos.x)
  e.pos.x = lerp(e.pos.x, obj.pos.x, interp)
  e.pos.y = lerp(e.pos.y, obj.pos.y, interp)]]
end)