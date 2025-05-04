function _init()
  fps = 60

  --june palette
  poke(0x5f2e,1)
  pal({[0]=0,129,2,11,137,130,143,7,8,9,10,138,12,140,136,14},1)

  set_stage(a_stage())
  c_pos = a_costume("pos", {x = 6, y = 6})
  c_col = a_costume("col", {col = 4})

  actor1 = add_actor{c_pos}
  actor2 = 2

  CUR_STAGE.update += a_script(function(_ENV)
    pos.x, pos.y = rnd(128), rnd(128)
  end, c_pos)

  CUR_STAGE.draw += a_script(function(_ENV)
    -- example of 'optional' costume
    -- BECAREFUL OF POTENTIAL GLOBALS NAMED THE SAME lol
    local c = 7
    if (col) c = col.col
    pset(pos.x, pos.y, c)
  end, c_pos)

  _set_fps(60)
  cls()
  ::play::
    m.x, m.y, m.click, m.scroll = stat(32), stat(33), stat(34), stat(36)
    acs_frame()
    flip()
  goto play
end

-- instead of running actors in a row we will run componenets
--  in a row, which store the actor data they then manipulate
--  the actor, using the scripts here

function acs_frame()
  CUR_STAGE.update()
  CUR_STAGE.draw()
  CUR_STAGE.post_draw()
end