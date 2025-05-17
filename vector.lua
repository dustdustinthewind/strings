function mt_vector(x, y, px, py)
  return setmetatable({x=x or 0, px=x or 0, y=y or 0, py=y or 0},
  {
    -- b is number or vector
    __add = function(self, b)
      if (type(b) == "number") b = {x=b, y=b}
      
      return mt_vector(self.x + b.x, self.y + b.y)
    end,

    __sub = function(self, b)
      if (type(b) == "number") b = {x=b, y=b}

      return mt_vector(self.x - b.x, self.y - b.y)
    end,

    -- scalar
    -- b is number
    __mul = function(self, b)
      return mt_vector(self.x * b, self.y * b)
    end,

    __div = function(self, b)
      return mt_vector(self.x / b.x, self.y / b.y)
    end,

    __tostring = function(self)
      return "("..self.x..","..self.y..")"
    end,

    __call = function(self)
      return self.x, self.y
    end,
  })
end