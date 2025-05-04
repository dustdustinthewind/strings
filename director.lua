function _init()
  fps = 60

  --june palette
  poke(0x5f2e,1)
  pal({[0]=0,129,2,11,137,130,143,7,8,9,10,138,12,140,136,14},1)

  set_stage(a_stage())
  c_pos = a_costume("pos", {x = 6, y = 6})
  c_col = a_costume("col", {col = 4})

  _=(CUR_STAGE
    + c_pos + c_col)
    * {c_pos} * {c_pos, c_col}


  CUR_STAGE.update += a_script(function(_ENV)
    pos.x, pos.y = rnd(128), rnd(128)
  end, c_pos)

  _=CUR_STAGE.draw
  + a_script(function(_ENV)
    -- example of 'optional' costume
    pset(pos.x, pos.y, col.col)
  end, c_pos, {a_costume("col", {col=7})})

  _set_fps(60)
  ::play::
    cls()
    --m.x, m.y, m.click, m.scroll = stat(32), stat(33), stat(34), stat(36)
    acs_frame()
    flip()
  goto play
end

-- instead of running actors in a row we will run componenets
--  in a row, which store the actor data they then manipulate
--  the actor, using the scripts here

function acs_frame()
  CUR_STAGE:update()
  CUR_STAGE:draw()
end

function set_stage(stage)
  CUR_STAGE = stage
  CUR_WARDROBE = CUR_STAGE.wardrobe
end

-- act = table of costumes that represent actor
-- returne index of actor
-- ACTOR_IND = ADD_ACTOR{...}
function add_actor(actor)
  CUR_STAGE *= actor
  return CUR_STAGE.last_index
end