{ graphics: lg, mouse: lm } = love

import wrapping_, Mixin from  require "util"
Vector = require "lib.hump.vector"

dummy = Vector!

wrapping_ class Dialogue extends Mixin
  new: (@scene, @character) =>
    super!

    @choices = {}

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

    DIALOGUE\register @, @character

  print: (text, x, y, limit, height, align, background) =>
    lg.setColor 0, 0, 0, 180

    if background
      lg.rectangle "fill", x, y, limit, height
    else
      lg.printf text, x+2, y-4, limit, align
      lg.printf text, x+2, y-3, limit, align

    lg.setColor 255, 255, 255, 255
    lg.printf text, x+1, y-4, limit, align

  new_text: (text) =>
    for choice in *@choices
      @scene.hit\remove choice.shape

    @choices = {}
    return unless text

    isChoice = true
    if "string" == type text
      text = { text }
      isChoice = false

    font = lg.getFont!
    { textpos: { :x, :y }, :limit, :align } = @
    @choices = for no, text in ipairs text
      height = 7 * #(select '2', font\getWrap(text, limit))
      shape = @scene.hit\rectangle x, y, limit, height
      with hit = {
          :text,
          :shape,
          :x, :y,
          :height
        }
        hit.shape.mousepressed = -> DIALOGUE\select isChoice and no
        y += height

  draw: (draw_group, draw_layer) =>
    for { :text, :x, :y, :height, :shape } in *@choices
      @print text, x, y, @limit, height, align, @scene.hoveritems[shape]