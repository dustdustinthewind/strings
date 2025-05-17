debug = true

function _init()
  fps = 60

  --june palette
  poke(0x5f2e,1)
  pal({[0]=0,129,2,11,137,130,143,7,8,9,10,138,12,140,136,14},1)

  set_stage(a_stage()
    + "pos"
    + "follow"
    + "mouse_simp"
    + "heart")

  make_mouse()

  add_actor{a_heart()}

  _=CUR_STAGE.update
    + pre_update_ppos
    + update_heart
    + post_update_lerp_follow

  _=CUR_STAGE.draw
    + draw_simp
    + draw_heart

  _set_fps(60)
  ::play::
    cls()
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