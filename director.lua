function _init()
  fps = 60

  --june palette
  poke(0x5f2e,1)
  pal({[0]=0,129,2,11,137,130,143,7,8,9,10,138,12,140,136,14},1)

  c_pos = a_costume("pos", {x = 6, y = 6})
  c_col = a_costume("col", {col = 4})

  current_stage = a_stage()
  current_stage += c_pos
  current_stage += c_col
  actor1 = current_stage:add_actor{c_pos}
  actor2 = 2

  current_stage.update += a_script(function(_ENV)
    pos.x, pos.y = rnd(128), rnd(128)
  end, c_pos)

  current_stage.draw += a_script(function(_ENV)
    -- example of 'optional' costume
    -- BECAREFUL OF POTENTIAL GLOBALS NAMED THE SAME LMFAO
    local c = 7
    if (col) c = col.col
    pset(pos.x, pos.y, c)
  end, c_pos)

  current_stage.draw += a_script(function(_ENV)
    pset(pos.x, pos.y, col.col)
  end, c_pos, c_col)

  poke(24365, 1)
  m = {x, y, click, scroll}

  _set_fps(60)
  cls()
  ::play::
    m.x, m.y, m.click, m.scroll = stat(32), stat(33), stat(34), stat(36)
    frame()
    flip()
  goto play
end

-- instead of running actors in a row we will run componenets
--  in a row, which store the actor data they then manipulate
--  the actor, using the scripts here

function frame()
  if m.click > 0 and #current_stage < 2 then
    current_stage.wardrobe.col += actor1
    current_stage *= {c_pos, c_col}
  elseif m.click == 0 and #current_stage == 2 then
    current_stage.wardrobe.col -= actor1
    current_stage /= actor2
  end
  current_stage.update()
  current_stage.draw()
  current_stage.post_draw()
end