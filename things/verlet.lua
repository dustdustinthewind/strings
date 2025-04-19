function a_verltex(x, y, constraints, d, gx, gy)
  local to_return = has_pos(x or 63, y or 63)
    + {
        drag = d or 0.85,
        gravity = a_vector(gx or 0, gy or 0.9),
        vel = a_vector(),
        update = function(_ENV)
          vel = delta * drag
          pos += vel + gravity
        end,
        draw = function(_ENV)
          pset(pos.x, pos.y, 8)
        end
      }
  for c in all(constraints or {}) do
    to_return += c
  end
  return to_return
end

-- verltex constraints aren't things but
--  we assume they're being attached
--  properly
function is_boxed(x,y,x1,y2)
  return {
    update = function()
      
    end
  }
end