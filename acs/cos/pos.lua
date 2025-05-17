function has_position(x, y)
  return a_costume("pos", mt_vector(x, y))
end

pre_update_ppos = a_script(function(_ENV)
  pos.px, pos.py = pos.x, pos.y
end, "pos")

--[[follow_type={
  exact=1,
  delay=2,
  lerp=3,
}]]
  
-- ACTOR index or puppet
-- NOTE: if need tokens make this number/puppet only
function follows(actor, interp)
  if (type(actor)=="number") actor = CUR_STAGE:wardrobe(actor)
  printh(actor.pos)
  return a_costume("follow", {interp = interp or 0.1, pos = actor.pos})
end

-- TODO: follow_types
--  ie other ways of "following" than lerp
post_update_lerp_follow = a_script(function(_ENV)
  pos.x = lerp(pos.x, follow.pos.x, follow.interp)
  pos.y = lerp(pos.y, follow.pos.y, follow.interp)
end, "pos", "follow")