-- red = 9
red_string = actor:extend({
    x1 = 0, y1 = 0,
    max_length = 2,
    length = 0,
    tension = 0,
    strands = {},

    update = function(_ENV)
        
    end,
})

-- ribbon test
-- by luchak

local rx={}
local ry={}
local ru={}
local rv={}
local segs=16
local seg_len=1

-- multigrid solve schedule, kind of overkill
-- but hey, let's use all the cpu we got
local steps={128,64,32,64,32,16,32,64,128,64,32,16,8,16,32,64,128,64,32,16,8,4,8,16,32,64,128,64,32,16,8,4,2,4,8,16,32,64,128,64,32,16,8,4,2,1,2,4,8,4,2,1,2,1}
-- here's a feasible one for 16 segments:
-- local steps={8,4,8,4,2,1}

local mx,my=64,64
function _init()
 poke(0x5f2d,0x1)
 mx,my=mid(0,stat(32),127),mid(0,stat(33),127)

 -- init ribbon
 for i=1,segs do
  add(rx,mx+i*seg_len)
  add(ry,my)
  add(ru,0)
  add(rv,0)
 end
end

-- higher values = lower drag
-- keep between 0 and 1
local drag=0.99

-- higher values = stronger gravity
local grav=0.05

local ground_friction=0.6

local dt=1

function _update60()
 mx,my=mid(0,stat(32),127),mid(0,stat(33),127)

 local nx,ny={},{}
 for i=1,segs do
  local x,y,u,v=rx[i],ry[i],ru[i],rv[i]
  v+=grav*dt
  u*=drag
  v*=drag

  nx[i],ny[i]=x+u*dt,y+v*dt
 end

 -- constraint solve
 for s in all(steps) do
  local step_seg_len=seg_len*s
  -- mouse point has infinite mass, so need to treat first segment specially
  local dx,dy=nx[s]-mx,ny[s]-my
  local dist=max(sqrt(dx*dx+dy*dy)/step_seg_len,1)
  nx[s]=mx+dx/dist
  ny[s]=my+dy/dist
  for i=s+s,segs,s do
   local cx,cy,px,py=nx[i],ny[i],nx[i-s],ny[i-s]
   local dx,dy=cx-px,cy-py
   local dist=max(sqrt(dx*dx+dy*dy)/step_seg_len,1)
   dx/=dist
   dy/=dist
   cmx2=cx+px
   nx[i]=(cmx2+dx)/2
   nx[i-s]=(cmx2-dx)/2
   cmy2=cy+py
   -- limit y position so we have a floor
   ny[i]=min((cmy2+dy)/2,127.9)
   ny[i-s]=min((cmy2-dy)/2,127.9)
  end
 end

 for i=1,segs do
  local x,y=nx[i],ny[i]
  local u=(x-rx[i])/dt
  -- ground friction, very hacky
  -- probably also needs some handling in constraint step
  if (y>127) u*=ground_friction
  local v=(y-ry[i])/dt

  rx[i],ry[i],ru[i],rv[i]=x,y,u,v
 end

 if (btnp(0)) drag=mid(0.8,drag+0.005,1)
 if (btnp(1)) drag=mid(0.8,drag-0.005,1)
 if (btnp(2)) grav=mid(0,grav+0.005,0.3)
 if (btnp(3)) grav=mid(0,grav-0.005,0.3)
 
end

function _draw()
 cls()
 line(mx,my,rx[1],ry[1],14)
 for i=2,segs do
  line(rx[i-1],ry[i-1],rx[i],ry[i],14)
 end
 pset(mx,my,8)
 print('⬅️➡️ drag: '..(1-drag),0,0,6)
 print('⬆️⬇️ grav: '..grav)
end
