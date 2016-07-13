{ graphics: lg } = love

import wrapping_, Mixin from  require "util"
import Dialogue from require "game.dialogue"
Vector = require "lib.hump.vector"

export DIALOGUE

wrapping_ class File extends Mixin
  new: (@scene) =>
    super!

    for layer in *@
      if layer.name == "pages"
        @pages = layer

    for page in *@pages
      page.origin = Vector page.ox, page.oy

  start: =>
    @page = 1
    @rebuild!

  rebuild: =>
    SCENE.hit\remove @lrect if @lrect
    SCENE.hit\remove @rrect if @rrect

    if @pages[@page]
      DIALOGUE = @
      @lrect = SCENE.hit\rectangle SCENE.scroll.x, SCENE.scroll.y, 160, SCENE.height
      @rrect = SCENE.hit\rectangle SCENE.scroll.x + 160, SCENE.scroll.y, 160, SCENE.height
      @lrect.prio, @lrect.mousepressed = 10, ->
        @page = math.max 1, @page - 1
        @rebuild!
      @rrect.prio, @rrect.mousepressed = 10, ->
        @page += 1
        @rebuild!
    else
      DIALOGUE = nil
      SCENE.state.police = 5
      SCENE.state.receptionist = "ready"
      Dialogue(=>
        @description\say "Specialized in drug dealers and club scene?"
        @description\say "I guess david johnson not only likes to take pictures..."
        @description\say "But how can i find him?"
      )\start!


  draw: (draw_group, draw_layer) =>
    layer = @pages[@page]
    if layer
      layer.ox, layer.oy = (layer.origin - SCENE.scroll)\unpack!
      draw_layer layer
