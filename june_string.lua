function a_string()
  return ent{} + is_string()
  + can_draw(draw_string)
end

function draw_string(e)
  for s in all(e.string.sticks) do
    if not s.hidden then
      line(s.p0.x,s.p0.y,s.p1.x,s.p1.y,8)	
    end
  end
end

--[[★★★★★★★★★★★★★★★★★★★★★★★★★★
             🐶  thank you mika-friend! 🐕
gist.github.com/mika76/4b559a8096d73414e24dd5bfb83c54c9
★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★]]
function is_string(x, y, l, sl, b, g, f)
  return cmp("string", birth_string(x,y,l,sl,b,g,f))
end

function pinned_string(pins, update)
  return cmp("pinned", {pins = pins, update = update})
end

pin_string = sys({"string", "pinned"}, function(e)
  for p in all(e.pinned.pins) do
    e.string.points[p].pinned = true
  end
  printh("hai")
  e.pinned.update(e)
end)

function birth_string(x, y, l, sl, b, g, f)
  local x, y = x or 63, y or 5
  june_string = {
    len = l or 11,
    seg_len = sl or 1,

    bounce = b or 0.9,
	  gravity = g or 0.1,
	  friction = f or 0.999,
  }
  local points = {}
  local sticks = {}

  for i=1, june_string.len do
    local x = x + i * june_string.seg_len
    add(points, {
      x  = x, y  = y,
      px = x, py = y,
    })
  end

  for i = 2, #points do
    local distance = function(p0, p1)
      local dx, dy = p1.x - p0.x, p1.y - p1.y
      return sqrt(dx*dx + dy*dy)
    end
    dx, dy = 
    add(sticks, {
      p0 = points[i-1],
      p1 = points[i],
      len = distance(points[i-1],points[i]),
    })

    june_string.points = points
    june_string.sticks = sticks
  end

  return june_string
end

string_dance = sys({"string"}, function(e)
  local _ENV = local_env(e.string)

  local friction, gravity, bounce = friction, gravity, bounce

  local update_points = function()
    for p in all(points) do
      printh(p)
      local _ENV = local_env(p)
      if not pinned then
        local vx,vy=(x-px)*friction,(y-py)*friction
        px=x
        py=y
        x+=vx
        y+=vy
        y+=gravity
      end
    end
  end

  local update_sticks = function()
    for s in all(sticks) do
      local _ENV = local_env(s)
      local dx,dy=p1.x - p0.x, p1.y - p0.y
      local dist=sqrt(dx*dx + dy*dy)
      local diff=len - dist
      local perc=diff / dist / 2
      local offx, offy = dx*perc, dy*perc
      
      if not p0.pinned then
        p0.x-=offx
        p0.y-=offy
      end
      if not p1.pinned then
        p1.x+=offx
        p1.y+=offy
      end
    end
  end

  local constrain_points = function()
    for p in all(points) do
      if not p.pinned then
        local vx, vy = (p.x-p.px) * friction, (p.y-p.py)*friction
                
    --[[if x>127 then
          x=127
          px=x+vx*bounce
        elseif x<0 then
          x=0
          p.px=p.x+vx*bounce
        end
        if p.y>127 then
          p.y=127
          p.py=p.y+vy*bounce
        elseif p.y<0 then
          p.y=0
          p.py=p.y+vy*bounce
        end]]
      end
    end
  end

  update_points()
  for i = 0,2 do
    update_sticks()
    constrain_points()
  end
end)