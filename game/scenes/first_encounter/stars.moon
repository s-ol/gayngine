Vector = require "lib.hump.vector"
import wrapping_, Mixin from  require "util"

wrapping_ class Parallax extends Mixin
  new: (@scene, x, y, scale=0) =>
    @scale = tonumber scale
    @move = Vector -tonumber(x), -tonumber(y)
    print @move
    @origin = Vector @ox - 44, @oy - 10
    @paused = true

  start: => @paused = nil

  update: (dt) =>
    @origin += @move * dt unless @paused
    @ox, @oy = (@origin - @scene.scroll * @scale)\unpack!
