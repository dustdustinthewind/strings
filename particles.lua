function a_blood_drop(x, y, vx, vy)
  local v = {x = vx or 0, y = vy or 0}
  return add(particles, ent{}
  + pos(x, y)
  + vel(v.x, v.y)
  + is_blood_drop()
  + can_draw(function(e)
    circfill(e.pos.x, e.pos.y, e.part.r, e.part.col)
  end))
end

-- todo particalize rope?
function is_blood_drop()
  return is_particle({
    r = (10+rnd(222))/100,
    friction = 0.92,
    col = rnd({8,14})
  }, function(e)
    e.vel.y += 0.2
    e.vel *= e.part.friction
    e.pos += e.vel
    e.part.r -= 0.04

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