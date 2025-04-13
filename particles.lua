function a_blood_drop(x, y, vx, vy)
  local v = {x = vx or 0, y = vy or 0}
  return add(particles, ent{}
  + pos(x, y)
  + vel(v.x, v.y)
  + is_blood_drop()
  + can_draw(function(e)
    circfill(e.pos.x, e.pos.y, e.part.r, 8)
  end))
end

-- todo particalize rope?
function is_blood_drop()
  return is_particle({
    r = 1+rnd(1)*1.2,
    friction = 0.9
  }, function(e)
    e.vel.y += 0.2
    printh(e.vel)
    e.vel *= e.part.friction
    printh(e.vel)
    e.pos += e.vel
    e.part.r -= 0.05

    if e.part.r <= 0 then
      del(particles, e)
      del(entities, e)
    end
  end)
end

function is_particle(part, update)
  local r = {update = update}
  for name, data in pairs(part) do
    r[name] = data
  end
  return cmp("part", r)
end

partical_update = sys({"part"}, function(e)
  e.part.update(e)
end)