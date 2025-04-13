function pos(x, y)
 return cmp("pos", setmetatable({x = x, y = y}, {
  __add = function(self, b)
    printh(b)
    self.x += b.x
    self.y += b.y
    return self
  end }))
end

function vel(x, y)
  return cmp("vel", setmetatable({x = x, y = y}, {
    __mul = function(self, b)
      self.x *= b
      self.y *= b
      return self
    end}))
end

--[[ has_phys
function has_gravity(grav)
  return cmp("grav", {grav = grav})
end]]

-- a custom draw function
function can_draw(draw)
  return cmp("draw", {draw = draw})
end