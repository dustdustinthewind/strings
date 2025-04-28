function deep_copy(table)
  if (type(table) ~= "table") return table

  local copy = {}
  for name, data in pairs(table) do
    copy[deep_copy(name)] = deep_copy(data)
  end
  setmetatable(copy, deep_copy(getmetatable(table)))
  
  return copy
end

function printall(table, name)
  printh((name or tostr(table))..":")
  for name, data in pairs(table) do
    if name and data then
      if (type(name) == "table") printall(name, "name table")
      printh(" "..tostr(name)..": "..tostr(data))
    end
  end
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
  return a + t * (b-a)
end