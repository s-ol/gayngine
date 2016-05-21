{graphics: lg, keyboard: lk, mouse: lm, audio: la, event: le} = love

import PSDSheet from require "psdsheet"
import Watcher from require "watcher"

export ^

WATCHER = Watcher!
Width, Height = lg.getDimensions!

one = PSDSheet "assets/anim.psd", .8

love.keypressed = (key) ->
  switch key
    when "escape"
      le.push "quit"

love.update = (dt) ->
  one\update dt

  WATCHER\update!

love.draw = ->
  one\draw!

  line = {}
  for point in *one.frames[3].mask.paths[1]
    line[#line+1] = point.cp.x
    line[#line+1] = point.cp.y

  love.graphics.polygon "line", line
