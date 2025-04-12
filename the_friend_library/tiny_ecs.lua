--tiny ecs v1.1
--by katrinakitten

--[[░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
  ♥☉🐱thank you, katrinakitten-friend!🐱☉♥  
  https://www.lexaloffle.com/bbs/?tid=39021
 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░]]

function ent(t)
    local cmpt={}
    t=t or {}
    setmetatable(t,{
     __index=cmpt,
     __add=function(self,cmp)
      assert(cmp._cn)
      self[cmp._cn]=cmp
      return self
     end,
     __sub=function(self,cn)
      self[cn]=nil
      return self
     end
    })
    return t
   end
   
   function cmp(cn,t)
    t=t or {}
    t._cn=cn
    return t
   end
   
   function sys(cns,f)
    return function(ents,...)
     for e in all(ents) do
      for cn in all(cns) do
       if(not e[cn]) goto _
      end
      f(e,...)
      ::_::
     end
    end
   end