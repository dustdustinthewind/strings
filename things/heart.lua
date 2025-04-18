function a_heart(tbl)
  printh("heart")
  return a_thing{
    draw = tbl.draw or function(_ENV)
      pset(pos.x, pos.y, col or 8)
    end
  }
  + has_pos(m.pos)
  + follows(m)
  + tbl
end