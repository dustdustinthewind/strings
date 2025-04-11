-- the dip will be the furthest point the rope can be from

function _init()
    --june colors 🐕
    poke(0x5f2e,1)
    pal({[0]=0,129,2,11,137,130,143,7,8,9,10,138,12,140,136,14},1)

    m = mouse()
    h = heart()
end

function _update60()
    m:update()
    h:update()
    --heart update
end

function _draw()
    cls()
    m:draw()
    h:draw()
    --heart draw
end