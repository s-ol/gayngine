{ graphics: lg, mouse: lm } = love

import wrapping_, Mixin from  require "util"
Vector = require "lib.hump.vector"

dummy = Vector!

wrapping_ class Dialogue extends Mixin
  new: (scene, @character) =>
    super!

    one, two = unpack @mask.paths[1]
    one, two = dummy.clone(one.cp), dummy.clone two.cp
    if two.x < one.x
      @align = "right"
      @textpos = two
      @limit = math.abs (one - two).x
    else
      @align = "left"
      @textpos = one
      @limit = math.abs (one - two).x

  print: (text, x, y, limit, align, background) =>
    lg.setColor 0, 0, 0, 180

    if background
      lg.rectangle "fill", x-1, y+4, limit, 7
    else
      lg.printf text, x+1, y, limit, align
      lg.printf text, x+1, y+1, limit, align

    lg.setColor 255, 255, 255, 255
    lg.printf text, x, y, limit, align

  draw: (draw_group, draw_layer) =>
    text = DIALOGUE\get @character
    return unless text

    { textpos: { :x, :y }, :limit, :align } = @

    if "string" == type text
      @print text, x, y - 7, limit, align
    else
      mx, my = lm.getPosition!
      mx, my = mx/4, my/4
      close = mx >= x and mx <= x + limit

      for no, choice in ipairs text
        hit = close and my >= y - 3 and my <= y + 4
        @print choice, x, y - 7, limit, align, hit
        y += 7

        if hit and lm.isDown 1
          DIALOGUE\select no
