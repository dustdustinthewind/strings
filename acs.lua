-- actor, costume, script!

-- a syntax-sweet, "entity-less" approach to ECS in pico-8
--            by dust 🐶
-- v0.0.1
-- 381 tokens

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

    -- use this instead of syntax sugar if you want to get
    --  index of actor
    -- CURRENT_STAGE:ADD_ACTOR{...}
    add_actor = function(self, tbl)      
      self *= tbl     
      return self.last_index
    end,
  },{
    __index = _ENV,

    -- add a costume to the wardrobe, do this before adding
    --  actors plzzzzz
    --  STAGE += COSTUME + COSTUME1 ...
    __add = function(self, cos)
      self.wardrobe[cos._name] = setmetatable({},{
        -- add a component to an actor (or more literally actor
        --  to the costume)
        -- CURRENT_STAGE.WARDROBE[COSTUME_NAME] += ACTOR_INDEX
        __add = function(self, actor_ind)
          self[actor_ind] = cos
          return self
        end,

        __sub = function(self, b)
          self[b] = nil
          return self
        end
      })
      return self
    end,

    -- remove a costume from the wardrobe
    __sub = function(self, costume)
      self.wardrobe[costume._name] = nil
      return self      
    end,

    -- hire an actor (in this case, a arr of components)
    --  actors are stars therefore
    -- STAGE *= ACTOR
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
    --  STAGE /= 69
    __div = function(self, actor_ind)
      local _ENV = self

      -- all() didn't work, and using i=1, #wardrobe didn't work
      --  but this does /shrug
      for name, data in pairs(wardrobe) do
        data -= actor_ind
      end

      if (find(open_roles, actor_ind)) return self
      
      for i=1, #open_roles+1 do
        if i == #open_roles+1 or actor_ind < open_roles[i] then
          add(open_roles, actor_ind, i)
          return self
        end
      end
    end,

    -- the current count of actors
    --  #CURRENT_STAGE
    __len = function(self)
      return self.cast - #self.open_roles
    end,
  })
end

-- system manager
function a_director()
  return setmetatable({},{
    -- UPDATE(), DRAW(), POSTDRAW()
    __call = function(self)
      for i=1,#self do self[i]() end
    end,
    
    -- STAGE.UPDATE += SCRIPT
    __add = function(self, script)
      self[#self+1] = script
      return self
    end,

    -- STAGE.UPDATE -= SCRIPT
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
-- req_cos = table of costumes this script needs to run
function a_script(scr, ...)
  return setmetatable({
    scr = scr,
    req_cos = {...},
  }, {
    __call = function(self)
      local _ENV = current_stage

      -- check each member of the cast
      for a=1, cast do
        local has_all = true
        local puppet = setmetatable({}, {__index = _ENV})
        
        for cos in all(self.req_cos) do
          -- if they aren't wearing any of the required costumes
          --  for script then skip to the next actor
          if wardrobe[cos._name] and wardrobe[cos._name][a] then
            puppet[cos._name] = wardrobe[cos._name][a]
          else
            has_all = false
            break
          end
        end

        -- if this turns out it does not keep reference then
        -- we could make scripts return the modified costumes
        if (has_all) self.scr(puppet)
      end
    end,
  })
end