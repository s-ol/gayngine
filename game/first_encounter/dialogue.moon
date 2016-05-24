import wrapping_, Mixin from  require "util"
Vector = require "lib.hump.vector"

require "moon.all"
dummy = Vector!

text =
  hector: {
    "what's up boyo?",
    "are you doing fine?",
    "",
  }
  raymond: {
    "",
    "",
    "fuck off.",
  }


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

  print: (text, x, y, limit, align) =>
    love.graphics.setColor 0, 0, 0, 180
    love.graphics.printf text, x+1, y, limit, align
    love.graphics.printf text, x+1, y+1, limit, align

    love.graphics.setColor 255, 255, 255, 255
    love.graphics.printf text, x, y, limit, align

  draw: (recursive_draw) =>
    @print text[@character][DIALOG_STATE] or "", @pos.x, @pos.y - 7, @limit, @align
