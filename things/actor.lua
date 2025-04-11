--[[
an actor plays on the stage!

     everyone is an actor

  what is your role?

       where is your stage?
]]
-- touched by https://github.com/kevinthompson/object-oriented-pico-8/blob/main/heartseeker.p8#L257
actor = thing:extend({
    roles = {}, -- a list of all actors on the current stage

    -- touched by core memories of our foundation
    extend = function(_ENV, tbl)
        tbl = thing.extend(_ENV, tbl)
        tbl.actors = {}
        return tbl
    end,

    -- tell every actor to do a dance
    each = function(_ENV, dance, ...)
        for a in all(roles) do
            if (a[dance]) a[dance](a, ...) -- if actor knows the dance, dance with needed props
        end
    end,

    x = 0,
    y = 0,

    w = 0,
    h = 0,

    init = function(_ENV)
        add(actor.roles, _ENV)
        if (roles != actor.roles) add(roles, _ENV)
    end,

--[[
   am i touching you ? are
     you   touching   me?
    we all touch each other

some are malicious w their touch

    some are over cautious..

  but we all touch each other

      who do you touch?

   who touches you  ? 

       are they good touches?

 good :3
]]
    touch =     function
    (_ENV , other)return
        x < other.x
          + other.w  and
        x + w 
          > other.x  and
        y < other.y
          + other.h  and
    h + y > other.y  end,

    destroy = function(_ENV)
        del(actor.roles, _ENV)
        if roles != actor.roles then
            del(roles, _ENV)
        end
    end,
})