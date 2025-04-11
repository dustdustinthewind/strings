-- mouse momager
--poke mouse
poke(24365,1)

mouse = actor:extend({
    click = 0,
    scroll = 0,

    update = function(_ENV)
        x = stat(32)
        y = stat(33)
        click = stat(34) -- 1 = left, 2 = right, 3 = both (double check)
        scroll = stat(36) -- 1 = scroll up, -1 = scroll down
    end,

    draw = function(_ENV)
        --pset(x, y, 8)
    end
})