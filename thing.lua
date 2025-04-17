-- thing 1.1
-- by dust

a_thing = function(tbl)
  return setmetatable({
    update = a_script(),
    draw = a_script(),
  }, {
    __index = _ENV,

    __add = function(self, b)
      for name,data in pairs(b or {}) do
        if type(data)~="function" then
          self[name] = data
        else
          add(self[name], data)
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