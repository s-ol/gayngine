import wrapping_, Mixin from  require "util"
Vector = require "lib.hump.vector"

require "moon.all"
dummy = Vector!

wrapping_ class Dialogue extends Mixin
  new: (@character) =>
    super!

    one, two = unpack @mask.paths[1]
    one, two = dummy.clone(one.cp), dummy.clone two.cp
    if two.x < one.x
      @align = "right"
      @pos = two
      @limit = math.abs (one - two).x
    else
      @align = "left"
      @pos = one
      @limit = math.abs (one - two).x

  draw: (recursive_draw) =>
    love.graphics.setColor 0, 0, 0, 180
    love.graphics.printf "what's up boyo?", @pos.x+1, @pos.y-6, @limit, @align
    love.graphics.printf "what's up boyo?", @pos.x+1, @pos.y-7, @limit, @align

    love.graphics.setColor 255, 255, 255, 255
    love.graphics.printf "what's up boyo?", @pos.x, @pos.y - 7, @limit, @align
