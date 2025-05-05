function printall(table, name)
  printh((name or tostr(table))..":")
  for name, data in pairs(table) do
    if name and data then
      if (type(name) == "table") printall(name, "name table")
      printh(" "..tostr(name)..": "..tostr(data))
    end
  end
end

function stats(...)
  local to_return = {}
  local i = 1
  for a in all{...} do
    to_return[i] = stat(a)
    i+=1
  end
  return unpack(to_return)
end

function find(table, value)
  for v in all(table) do
    if (v == value) return true 
  end
  return false
end

function local_env(new_env)
  return setmetatable(new_env, {__index = _ENV})
end

function lerp(a,b,t)
  return a + t * (b - a)
end