-- mouse womanager
poke(24365, 1) -- 5 if we wanna mouse lock (maybe)

is_mouse = a_costume("mouse", {click = 0, scroll = 0})

-- hire mouse to STAGE
function make_mouse(stage)
  if (m) return
  stage = stage or CUR_STAGE
  
  stage += is_mouse

  -- "m.x" will give you m.pos.x
  -- "m.click" will give you m.mouse.click
  m = setmetatable(stage:wardrobe(
    add_actor{has_position(stat(32), stat(33)), is_mouse}),
    { __index = function(self, key)
      return self.pos[key] or self.mouse[key]
    end }
  )
  
  stage.update += a_script(function(_ENV)
    pos.x, pos.y, mouse.click, mouse.scroll = stats(32, 33, 34, 36)
  end, "mouse")

  if (debug) then
    stage.draw += a_script(function(_ENV)
      pset(pos.x, pos.y, 7)
    end, "mouse")
  end
end

-- i mean mouse girls *are* hot
function a_mouse_simp(interp)
  return has_position(), follows(m, interp), "mouse_simp"
end