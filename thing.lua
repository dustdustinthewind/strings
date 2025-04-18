-- thing 1.1.1
-- by dust

a_thing = function(tbl)
  return setmetatable({
    update = a_script(),
    draw = a_script(),
  }, {
    __index = _ENV,

    __add = function(self, b)
      for name,data in pairs(b or {}) do
        if name == "update" or name == "draw" then
          add(self[name], data, #self+1)
        else
          self[name] = data
        end
      end
      return self
    end
  }) + tbl -- if a_thing{} has draw/update, we will add those to
           -- the draw/update scripts
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