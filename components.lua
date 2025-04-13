function pos(x, y)
 return cmp("pos", {x = x, y = y})
end

-- a custom draw function
function can_draw(draw)
  return cmp("draw", {draw = draw})
end