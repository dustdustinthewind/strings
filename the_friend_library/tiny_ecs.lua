--tiny ecs v1.2
--[[░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
  ♥☉ thank you, katrinakitten🐱friend! ☉♥  
  https://www.lexaloffle.com/bbs/?tid=39021
 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░]]

-- modified by dust
--  component data with the same name as their parent component
--   will insert themselves at e[cn] instead of e[cn][dn]
-- todo: systems modify _env to access both e and global?
--  think i will do this manually as needed within the sys func

function ent(t)
    local cmpt = {}
    t = t or {}
    setmetatable(t, {
     __index = cmpt,
     __add = function(self, cmp)
      assert(cmp._cn)
      -- i dont want to call e.draw().draw()
      -- just let me call e.draw()
      for dn, d in next, cmp do
        if (dn == cmp._cn) then
          self[cmp._cn] = d
          return self
        end
      end
      self[cmp._cn] = cmp
      return self
     end,
     __sub = function(self, cn)
      self[cn] = nil
      return self
     end
    })
    return t
   end
   
   function cmp(cn, t)
    t = t or {}
    t._cn = cn
    return t
   end
   
   function sys(cns, f)
    return function(ents,...)
     for e in all(ents) do
      for cn in all(cns) do
       if(not e[cn]) goto _
      end
      f(e, ...)
      ::_::
     end
    end
   end