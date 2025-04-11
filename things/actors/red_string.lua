-- thank you luchak friend! https://www.lexaloffle.com/bbs/?tid=47957
red_string = actor:extend({

    rx={},
    ry={},
    ru={},
    rv={},
    segs = 16,
    seg_len = 1.1,

    -- multigrid solve schedule, kind of overkill
    -- but hey, let's use all the cpu we got
    --local steps={128,64,32,64,32,16,32,64,128,64,32,16,8,16,32,64,128,64,32,16,8,4,8,16,32,64,128,64,32,16,8,4,2,4,8,16,32,64,128,64,32,16,8,4,2,1,2,4,8,4,2,1,2,1}
    -- here's a feasible one for 16 segments:
    steps={8, 4, 8, 4, 2, 1},

    x1 = 0,
    y1 = 0,

    init = function(_ENV)
        -- init ribbon
        for i = 1, segs do
            add(rx, x1)
            add(ry, y1 + i * seg_len)
            add(ru, 0)
            add(rv, 0)
        end
    end,

    -- higher values = lower drag
    -- keep between 0 and 1
    drag = 0.99,

    -- higher values = stronger gravity
    grav = 0.05,

    ground_friction = 0.6,

    dt = 1,

    update = function(_ENV)
        local nx, ny = {}, {}
        for i = 1 , segs do
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
            local dx,dy=nx[s]-x1,ny[s]-y1
            local dist=max(sqrt(dx*dx+dy*dy)/step_seg_len,seg_length)
            nx[s]=x1+dx/dist
            ny[s]=y1+dy/dist
            for i=s+s,segs,s do
                local cx,cy,px,py=nx[i],ny[i],nx[i-s],ny[i-s]
                local dx,dy=cx-px,cy-py
                local dist=max(sqrt(dx*dx+dy*dy)/step_seg_len,seg_length)
                dx/=dist
                dy/=dist
                cx12=cx+px
                nx[i]=(cx12+dx)/2
                nx[i-s]=(cx12-dx)/2
                cy12=cy+py
                -- limit y position so we have a floor
                ny[i]=min((cy12+dy)/2,127.9)
                ny[i-s]=min((cy12-dy)/2,127.9)
            end
        end

        for i=1,segs do
            local x,y=nx[i],ny[i]
            local u=(x-rx[i])/dt
            -- ground friction, very hacky
            -- probably also needs some handling in constraint step
            --if (y>127) u*=ground_friction
            local v=(y-ry[i])/dt

            rx[i],ry[i],ru[i],rv[i]=x,y,u,v
        end

        if (btnp(0)) drag = mid(0.8,drag+0.005,1)
        if (btnp(1)) drag = mid(0.8,drag-0.005,1)
        if (btnp(2)) grav = mid(0,grav+0.005,0.3)
        if (btnp(3)) grav = mid(0,grav-0.005,0.3)
    end,

    draw = function(_ENV)
        line(x1, y1, rx[1], ry[1], 14)
        for i = 2, segs do
            line(rx[i-1],ry[i-1],rx[i],ry[i],8)
        end
        --print('⬅️➡️ drag: '..(1-drag),0,0,6)
        --print('⬆️⬇️ grav: '..grav)
    end,
})