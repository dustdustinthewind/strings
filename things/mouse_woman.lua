-- mouse womanager
poke(24365, 1)

m = a_thing{
  click = 0, scroll = 0,

  update = function(_ENV)
    pos.x,pos.y,click,scroll = stat(32), stat(33), stat(34), stat(36)
  end
} + has_pos(stat(32), stat(33))