-- verlet vectors
function has_pos(x, y)
  local x,y = x or 0, y or 0
  return a_thing{
    pos = a_vector(x, y),
    ppos = a_vector(x, y),
    delta = a_vector(),
    
    update = function(_ENV)
      if type(pos.x)=="table" then
        for name,data in pairs(pos.x) do
          printh(name..tostr(data))
        end
      end
      delta = pos - ppos
      ppos = pos
    end
  }
end

  follows = function(thng)
    return has_pos() +
      {
        follows = thng,
        pos = thng.pos,
        update = function(_ENV)
          pos = thng.pos
        end
      }
  end

function has_vel(x, y)
  return a_thing{
    vel = a_vector(x, y),
  }
end

function num_or_vec(b)
  if type(b) == "number" then
    return b, b
  else
    return b.x, b.y
  end
end

function a_vector(x, y)
  return setmetatable({x = x or 0, y = y or 0},{
    __add = function(self, b)
      local bx, by = num_or_vec(b)
      return a_vector(self.x + bx, self.y + by)
    end,

    __sub = function(self, b)
      local bx, by = num_or_vec(b)
      return a_vector(self.x - bx, self.y - by)
    end,

    __mul = function(self, b)
      local bx, by = num_or_vec(b)
      return a_vector(self.x * bx, self.y * by)
    end,
  })
end