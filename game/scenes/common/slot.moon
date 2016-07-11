{ graphics: lg, mouse: lm } = love

import wrapping_, Mixin from  require "util"
Vector = require "lib.hump.vector"
utf8 = require "utf8"

dummy = Vector!
clearfix = "                                "
clearfix ..= clearfix .. clearfix .. clearfix

wrapping_ class Slot extends Mixin
  SPEED = 25
  FAST_SPEED = SPEED * 4
  @INSTANCES = {}
  new: (@scene, @character, @sprite) =>
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

  print: (lines, x, y, width, height, align, hover) =>
    if align == "right"
      x -= width - @limit

    if hover
      x += 2

    height = 7

    chars = @chars
    for text in *lines
      if chars
        if chars < 1
          text = ""
        else
          start = text\sub 1, (utf8.offset(text, math.floor chars + 1) or math.floor chars + 1) - 1
          chars -= utf8.len text
          text = start\gsub "%%", ""

      if hover
        lg.setColor 0, 0, 0, 200
        lg.rectangle "fill", x, y, width+2, height
      else
        lg.setColor 0, 0, 0, 120
        lg.rectangle "fill", x, y, width+1, height

      lg.setColor 255, 255, 255, 255
      lg.printf text, x+1, y-4, width
      y += 7

  clear: =>
    for choice in *@choices
      @scene.hit\remove choice.shape
    @choices = {}

    @speed = SPEED
    @chars, @maxchars = nil, nil

  say: (text, next) =>
    font = lg.getFont!
    { textpos: { :x, :y }, :limit } = @
    width, lines = font\getWrap text\gsub("%%", ""), limit
    height = 7 * #lines
    shape = @scene.hit\rectangle 0, 0, @scene.width, @scene.height
    choice = {
      :lines,
      :shape,
      :x, :y,
      :width, :height
    }
    choice.shape.mousepressed = ->
      if @chars >= @maxchars
        DIALOGUE\next next
      else
        @speed = FAST_SPEED

    choice.shape.prio = 200
    @choices = { choice }
    @chars = 0
    @maxchars = utf8.len text

    coroutine.yield! unless next

  rchoice: (choices) =>
    font = lg.getFont!
    { textpos: { :x, :y }, :limit } = @
    @choices = for tbl in *choices
      key, label = next tbl
      text = "- #{label}"

      width, lines = font\getWrap text\gsub("%%", ""), limit
      height = 7 * #lines
      shape = @scene.hit\rectangle x, y, width+3, height
      with choice = {
          :lines,
          :shape,
          :x, :y,
          :width, :height
        }
        choice.shape.mousepressed = ->
          DIALOGUE\next key
        choice.shape.prio = 200
        y += height

    coroutine.yield!

  choice: (...) =>
    choices = { ... }

    font = lg.getFont!
    { textpos: { :x, :y }, :limit } = @
    @choices = for tbl in *choices
      key = next tbl
      while key and "_" == key\sub 1, 1
        key = next tbl, key

      text = "- #{tbl._label or key}"

      width, lines = font\getWrap text\gsub("%%", ""), limit
      height = 7 * #lines
      shape = @scene.hit\rectangle x, y, width+3, height
      with choice = {
          :lines,
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

  update: (dt) =>
    @chars = math.min @maxchars, @chars + dt * @speed if @chars and @maxchars

  draw: (draw_group, draw_layer) =>
    lg.push!
    lg.translate @scene.scroll\unpack! if @sprite
    for { :lines, :x, :y, :width, :height, :shape } in *@choices
      @print lines, x, y, width, height, @align, @scene.hoveritems[shape] and #@choices != 1
    lg.pop!
