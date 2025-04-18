has_pos = function(x, y)
  return a_thing{
    pos = { x = x or 0, px = x or 0,
            y = y or 0, py = y or 0 },
    
    update = function(_ENV)
      px, py = x, y
    end,

    delta = function(_ENV)
      return {x = x-px, y = y-py}
    end
  }
end

follows = function(thng)
  return a_thing{
    follows = thng,
    update = function(_ENV)
      pos.x, pos.y = thng.pos.x, thng.pos.y
    end
  }
end