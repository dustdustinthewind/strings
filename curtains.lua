function curtains()
  return ent{}
  -- this uses 15% of our budget on 60fps
  + can_draw(function()
      -- to save even more performance and add evend more weird
      -- uneven pixel details, split into more and smaller squares
      -- no transparency borders
      sspr(0, 64, 3, 64, 0, 0, 5, 128)
      sspr(0, 64, 3, 64, 128, 0, -6, 128)
      -- top curtain
      sspr(3, 64, 32, 16, 5, 0, 58, 30.5)
      sspr(3, 80, 14, 48, 5, 28.5, 23, 94.5)
      -- inside curtain
      sspr(3, 64, 32, 16, 123, 0, -60, 31.5)
      sspr(3, 80, 14, 48, 123, 28.5, -24, 93.5)
    end)
  end