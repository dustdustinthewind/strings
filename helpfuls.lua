function local_env(new_env)
  return setmetatable(new_env, {__index = _ENV})
end

function lerp(a,b,t)
  return a + t * (b-a)
end