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

-- a unity developer's overused and overshared sex toy
-- a and b are anything that can have math done to it
-- t is ideally a number from 0 to 1, i mean idfc i'm not your mom
function lerp(a, b, t)
  return a + (b - a) * t
end

function deep_copy(table)
  if (type(table) ~= "table") return table

  local copy = {}
  for name, data in pairs(table) do
    copy[deep_copy(name)] = deep_copy(data)
  end
  setmetatable(copy, deep_copy(getmetatable(table)))

  return copy
end