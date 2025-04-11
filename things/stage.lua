--[[
      a stage is a world

what does your stage look like?!

 mine is very dark
             but its bright too!
  i must focus the bright

what is an actor wo its stage?
  lost?  ░  scared?  ░  real?
]]
-- thanks, friend! https://github.com/kevinthompson/object-oriented-pico-8/blob/main/heartseeker.p8
stage = thing:extend({
    current = nil, -- the current stage the mirror is looking at

    update = noop,
    draw = noop,

    -- when we are no longer looking at this stage
    -- we must say farewell to it and its inhibitants
    --  its ok! they still exist, waiting for us to watch them dance again
    -- we can't keep everyone in the active brain
    -- but we can keep them safe here in the certainty of memory
    destroy = function(_ENV)
        actor:each("destroy")
    end,
})