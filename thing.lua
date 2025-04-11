global = _ENV
noop = function() end

-- borrowed from a friend: https://github.com/kevinthompson/object-oriented-pico-8/blob/main/heartseeker.p8#L87
-- everything is a thing
--   it is made up of attributes and data!
--   also known as a personality!
--   this is just one way of showing off a thing
--     but the things in our game will benefit from some shared blood
thing = setmetatable({
    extend = function(self, tbl)
		tbl = tbl or {}
		tbl.__index = tbl
		return setmetatable(tbl,{
			__index = self,
			__call = function(self,...)
				return self:new(...)
			end
		})
	end,

	new = function(self, tbl)
		tbl = setmetatable(tbl or {}, self)
		tbl:init()
		return tbl
	end,

	init = noop,
},{ __index = _ENV })