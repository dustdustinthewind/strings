-- actor, costume, script!

-- a syntax-sweet, "entity-less" approach to ECS in pico-8
--            by dust 🐶
-- v0.0.1 - 381 tokens
--  base ECS and syntax
-- v0.0.2 - 421 tokens
--  globals CUR_STAGE/CUR_WARDROBE added for accessibility/tokens
--  a_costume() now adds costume to CUR_WARDROBE if not already in
--  set_stage()
--  removed dependency on find() from outside acs
-- v0.0.2.1 - 412 tokens
--  a_costume() does not add itself to cur_wardrobe anymore lol
-- v0.0.3 - 481 tokens
--  fixed bugs caused by v0.0.2.1 lol
--  moved deep_copy() dependency into acs.lua darn, token uppage xd
--  better support for {optional} costumes in script requirements
-- v0.0.4 - 467 tokens
--  removed post_draw() director
--  removed set_stage(), add_actor() and CUR_STAGE/CUR_WARDROBE shenanigans
--   im gonna use these still but i want them outside of acs
--   instead of encouraging it as a default here
--  STAGE += COSTUME only accepts costumes so default costume can
--   be set
--  stage:wardrobe(i) will return a "puppet" containing a reference
--   to every costume in wardrobe with that index
-- v0.0.4.1 - 475 tokens
--  script.req_cos can include strings representing name instead
--   of requiring explicilty costumes with COS._NAME

-- thanks to:
--  katrinakitten friend!
--   for tiny ecs! https://www.lexaloffle.com/bbs/?tid=39021
--  robert nystrom friend!
--   for game programming patterns! https://gameprogrammingpatterns.com/  

-- world analog
function a_stage()
  return setmetatable({
    -- max number of actors/entities,
    --  only goes up when hiring an actor and no open_roles
    cast = 0,
    -- free slots, if we fire an actor, we mark role open here
    open_roles = {},
    -- last index assigned
    last_index = -1,

    -- costumes / components
    wardrobe = setmetatable({}, {
      -- CUR_STAGE:WARDROBE(ACTOR_INDEX) will return a "puppet" of that
      --  actor. useful if you want to keep an eye on an actors
      --  stats in one place
      __call = function(self, _ENV, act_ind)
        local puppet = setmetatable({}, { __index = _ENV })
        for name, data in pairs(self) do
          puppet[name] = data[act_ind]
        end
        return puppet
      end
    }),
    
    --directors direct cast to follow scripts
    --system managers
    update = a_director(),
    draw = a_director(),
  },{
    __index = _ENV,

    -- add a costume to the wardrobe
    -- cur_stage += COSTUME
    __add = function(self, cos)
      self.wardrobe[cos._name] = setmetatable({_default = cos},{
        -- add a component to an actor (or more literally actor
        --  to the costume)
        -- cur_wardrobe[COSTUME_NAME] += ACTOR_INDEX
        __add = function(self, act_ind)
          self[act_ind] = deep_copy(self._default)
          return self
        end,

        -- cur_wardrobe[COSTUME_NAME] -= ACTOR_INDEX
        __sub = function(self, act_ind)
          self[act_ind] = nil
          return self
        end,
      })
      
      return self
    end,

    -- remove a costume from the wardrobe
    -- cur_stage -= "COS_NAME"
    --  or
    -- cur_stage -= COSTUME
    __sub = function(self, cos)
      self.wardrobe[cos._name or cos] = nil
      return self      
    end,

    -- hire an actor (in this case, a arr of components)
    --  actors are stars therefore
    -- cur_stage *= ACTOR
    -- ACTOR is a list of costumes/costume names
    __mul = function(self, actor)
      local _ENV = self

      local index
      if #open_roles ~= 0 then
        index = del(open_roles, open_roles[1])
      else
        cast += 1
        index = cast
      end

      for cos in all(actor) do
        if (not cos._name) cos = wardrobe[cos]._default
        wardrobe[cos._name or cos][index] = deep_copy(cos)
      end

      last_index = index
      return self
    end,

    -- fire an actor at index
    --  looks like they got.. "slashed" from the job eeeh? :3
    --  cur_stage /= 69
    __div = function(self, actor_ind)
      local _ENV = self

      -- all() didn't work, and using i=1, #wardrobe didn't work
      --  but this does /shrug
      local is_nil = true -- does this actor exist?
      for cos_name, cos in pairs(wardrobe) do
        if (cos[actor_ind]) is_nil = false -- yes it does
        cos -= actor_ind
      end

      if (is_nil) return self -- if actor didn't exist, don't care
      
      -- otherwise add it to open roles
      for i = 1, #open_roles + 1 do
        if i == #open_roles + 1 or actor_ind < open_roles[i] then
          add(open_roles, actor_ind, i)
          return self
        end
      end
    end,

    -- the current count of actors
    --  #cur_stage
    __len = function(self)
      return self.cast - #self.open_roles
    end,
  })
end

-- system manager
function a_director()
  return setmetatable({},{
    -- cur_stage:UPDATE(), cur_stage:DRAW()
    __call = function(self, stage)
      for i=1,#self do self[i](stage) end
    end,
    
    -- cur_stage.UPDATE() += SCRIPT
    __add = function(self, script)
      add(self, script)
      return self
    end,

    -- cur_stage.UPDATE() -= SCRIPT
    __sub = function(director, script)
      del(self, script)
      return self
    end,
  })
end

-- component analog
function a_costume(name, costume)
  local data = costume or {}
  data._name = name
  return data
end

-- system analog
-- req_cos = list of costumes this script needs to run
--            you can use optional costumes by putting them in a
--            table within the list
-- A_SCRIPT(SCRIPT_FUNC, REQ_COS, REQ_COS2, {OPT_COS, OPT_COS2})
function a_script(func, ...)
  return setmetatable({
    scr = func,
    req_cos = {...},
  }, {
    __call = function(self, _ENV)
      -- check each member of the cast
      -- NOTE: this includes "fired" cast members. so, if theres
      --  a cast of 100 but all but #100 is fired, then this will
      --  still loop 100 times. performance implications? meh
      -- TODO: have systems track what indexes they're in charge of?
      for a = 1, cast do
        local puppet = _ENV:wardrobe(a)
        
        for cos in all(self.req_cos) do
          -- if a non-costume table, its a list of optional costumes
          if not cos._name and type(cos) == "table" then
            for opt in all(cos) do
              puppet[opt._name or opt] = puppet[opt._name or opt] or opt
            end
          -- if cos is costume or string
          -- if they aren't wearing any of the required costumes
          --  for script then skip to the next actor
          elseif not puppet[cos._name or cos] then
            goto continue
          end
        end

        self.scr(puppet)
        ::continue::
      end
    end,
  })
end

-- helpers :3
function deep_copy(table)
  if (type(table) ~= "table") return table

  local copy = {}
  for name, data in pairs(table) do
    copy[deep_copy(name)] = deep_copy(data)
  end
  setmetatable(copy, deep_copy(getmetatable(table)))

  return copy
end