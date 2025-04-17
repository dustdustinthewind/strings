-- thing 1.0
-- by dust

a_thing = function(tbl)
  return setmetatable({
    -- queues
    update = a_script(),
    draw = a_script(),
  }, {
    __index = _ENV,

    __add = function(self, b)
      local b = b or {}
      assert(type(b) == "table")
      for name,data in pairs(b) do
        local is_update, is_draw =
          name == "update", name == "draw"

        if is_update then
          add(self.update, data)
        elseif is_draw then
          add(self.draw, data)
        else
          self[name] = data
        end
      end
      return self
    end
  })
  + tbl -- important line but can be hard to see so comment
end

function a_script()
  return setmetatable({}, {
    __call = function(self, _ENV)
      for q in all(self) do
        q(_ENV)
      end
    end,
  })
end