a_stage = function(tbl)
   -- things will be drawn in layer order
  return a_thing{
    layer = {
      a_layer{m}, -- pre-everything / background
      a_layer{}, -- stage
      a_layer{a_verltex(63,5)}, -- foreground
      a_layer{}, -- ui/ audience
    },

    update = function(_ENV)
      for i=0, #layer do
        for t in all(layer[i]) do
          t:update()
        end
      end
    end,

    draw = function(_ENV)
      cls(bg_col or 0)
      for i=0, #layer do
        for t in all(layer[i]) do
          t:draw()
        end
      end
    end,
  } + tbl
end

a_layer = function(tbl)
  return setmetatable(tbl or {}, {
    __add = function(self, thng)
      add(self, thng)
      return self
    end
  })
end