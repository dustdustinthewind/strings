heart = actor:extend({
    --todo heart/mouse object
    -- todo: use the rat?
    beat1 = 3.43,
    beat2 = 10,
    beat_speed = 1,
    speed_inc = 0.06,
    sprite1 = 66,
    sprite2 = 67,
    spr_counter = 0,
    clickable = false,
    on_beat = true,

    update = function(_ENV)
        clickable = m.click > 0
        spr_counter = spr_counter + beat_speed
        if on_beat then
            if not (spr_counter > beat1) then
                if clickable then 
                    sprite1 = 68
                else
                    sprite1 = 64
                end
                sprite2 = 65
            else
                on_beat = false
                sfx(2,2)
                spr_counter = 0
            end
        else
            if not (spr_counter > beat2) then
                if clickable then
                    sprite1 = 69
                else
                    sprite1 = 66
                end
                sprite2 = 67
            else
                on_beat = true
                sfx(1,1)
                spr_counter = 0
            end
        end

        beat_speed = mid(0.2, beat_speed + stat(36) * speed_inc, beat1)
    end,

    draw = function(_ENV)
        spr(sprite1, m.x-8, m.y-16, 1, 2)
        spr(sprite2, m.x,   m.y-16, 1, 2)
    end
})