--june colors 🐕
poke(0x5f2e,1)
pal({[0]=0,129,2,11,137,130,143,7,8,9,10,138,12,140,136,14},1)

function _init()
  current_stage = a_stage{}
  current_stage.layer[2] += a_heart{col = 3}
end

function _update60()
  current_stage:update()
end

function _draw()
  current_stage:draw()
end