{ graphics: lg, mouse: lm } = love

import wrapping_, Mixin from  require "util"
Vector = require "lib.hump.vector"

dummy = Vector!

wrapping_ class Slot extends Mixin
  @INSTANCES = {}
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

    if @character
      @@INSTANCES[@character] = @
    else
      table.insert @@INSTANCES, @

  print: (text, x, y, width, height, align, hover) =>
    if hover
      x += 2
      lg.setColor 0, 0, 0, 200
      lg.rectangle "fill", x, y, width+2, height
    else
      lg.setColor 0, 0, 0, 120
      lg.rectangle "fill", x, y, width+1, height

     -- lg.printf text, x+2, y-4, width, align
     -- lg.printf text, x+2, y-3, width, align

    lg.setColor 255, 255, 255, 255
    lg.printf text, x+1, y-4, width, align

  clear: =>
    for choice in *@choices
      @scene.hit\remove choice.shape
    @choices = {}

  say: (text, next) =>
    font = lg.getFont!
    { textpos: { :x, :y }, :limit } = @
    width, height = font\getWrap text, limit
    height = 7 * #height
    shape = @scene.hit\rectangle 0, 0, @scene.width, @scene.height
    choice = {
      :text,
      :shape,
      :x, :y,
      :width, :height
    }
    choice.shape.mousepressed = ->
      DIALOGUE\next next
    choice.shape.prio = 200
    @choices = { choice }

    coroutine.yield! unless next

  choice: (...) =>
    choices = { ... }

    font = lg.getFont!
    { textpos: { :x, :y }, :limit } = @
    @choices = for tbl in *choices
      key = next tbl
      while key and "_" == key\sub 1, 1
        key = next tbl, key

      text = "- #{tbl._label or key}"

      width, height = font\getWrap text, limit
      height = 7 * #height
      shape = @scene.hit\rectangle x, y, width+3, height
      with choice = {
          :text,
          :shape,
          :x, :y,
          :width, :height
        }
        choice.shape.mousepressed = ->
          @clear!
          @say tbl[key], key
        choice.shape.prio = 200
        y += height

    coroutine.yield!

  draw: (draw_group, draw_layer) =>
    for { :text, :x, :y, :width, :height, :shape } in *@choices
      @print text, x, y, width, height, @align, @scene.hoveritems[shape] and #@choices != 1
