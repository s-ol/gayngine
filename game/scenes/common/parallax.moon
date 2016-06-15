Vector = require "lib.hump.vector"
import wrapping_, Mixin from  require "util"

wrapping_ class Parallax extends Mixin
  new: (@scene, rate, offset) =>
    @rate = tonumber rate
    offset = tonumber offset or "0"
    @origin = Vector @ox - offset, @oy

  update: =>
    @ox, @oy = (@origin - @scene.scroll * @rate)\unpack!
