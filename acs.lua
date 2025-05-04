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
--  a_costume() does not add itself to cur_wadrobe anymore lol

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
    wardrobe = {},
    
    --directors direct cast to follow scripts
    --system managers
    update = a_director(),
    draw = a_director(),
    post_draw = a_director(),
  },{
    __index = _ENV,

    -- add a costume to the wardrobe
    -- cur_stage += COSTUME
    --  or
    -- cur_stage += "COS_NAME"
    __add = function(self, cos)
      cos = _find_costume_name_from(cos)
      
      self.wardrobe[cos] = setmetatable({},{
        -- add a component to an actor (or more literally actor
        --  to the costume)
        -- cur_wardrobe[COSTUME_NAME] += ACTOR_INDEX
        __add = function(self, actor_ind)
          self[actor_ind] = cos
          return self
        end,

        -- cur_wardrobe[COSTUME_NAME] -= ACTOR_INDEX
        __sub = function(self, actor_ind)
          self[actor_ind] = nil
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
      cos = _find_costume_name_from(cos)

      self.wardrobe[cos] = nil
      return self      
    end,

    -- hire an actor (in this case, a arr of components)
    --  actors are stars therefore
    -- cur_stage *= ACTOR
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
        wardrobe[cos._name][index] = deep_copy(cos)
      end

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
    -- cur_stage.UPDATE(), cur_stage.DRAW(), cur_stage.POST_DRAW()
    __call = function(self)
      for i=1,#self do self[i]() end
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

CUR_STAGE, CUR_WARDROBE = {}, {}

function set_stage(stage)
  CUR_STAGE = stage
  CUR_WARDROBE = CUR_STAGE.wardrobe
end

set_stage(a_stage())

-- act = table of costumes that represent actor
-- returne index of actor
-- ACTOR_IND = CUR_STAGE:ADD_ACTOR{...}
function add_actor(act)      
  CUR_STAGE *= act     
  return CUR_STAGE.last_index
end

-- component analog
function a_costume(name, costume)
  local data = costume or {}
  data._name = name
  return data
end

-- system analog
-- req_cos = table of costumes this script needs to run
function a_script(scr, ...)
  return setmetatable({
    scr = scr,
    req_cos = {...},
  }, {
    -- cur_stage.UPDATE(), cur_stage.DRAW(), cur_stage.POST_DRAW()
    __call = function(self)
      local _ENV = CUR_STAGE

      -- check each member of the cast
      --  NOTE: this includes "fired" cast members. so, if theres
      --   a cast of 100 but all but #100 is fired, then this will
      --   still loop 100 times. performance implications? meh
      for a = 1, cast do
        local puppet = setmetatable({}, { __index = _ENV })
        
        for cos in all(self.req_cos) do
          -- if they aren't wearing any of the required costumes
          --  for script then skip to the next actor
          if wardrobe[cos._name][a] then
            puppet[cos._name] = wardrobe[cos._name][a]
          else
            goto continue end
        end

        self.scr(puppet)
        ::continue::
      end
    end,
  })
end


function _find_costume_name_from(cos)
  -- if a table with "_name" then return it
  if (cos._name) return cos._name
  -- otherwise its prolly a string return what we got
  return cos
end