Vector = require "lib.hump.vector"

(scene, name, volume=1) =>
  p = @mask.paths[1][1].cp
  pos = Vector p.x, p.y

  SOUND\play name, volume, true, pos
