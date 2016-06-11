Vector = require "lib.hump.vector"
import wrapping_, Mixin from  require "util"

wrapping_ class Parallax extends Mixin
  new: (@scene, rate) =>
    @rate = tonumber rate
    @origin = Vector @ox, @oy

  update: =>
    @ox, @oy = (@origin - @scene.scroll * @rate)\unpack!
