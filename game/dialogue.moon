Vector = require "lib.hump.vector"
Slot = require "game.scenes.common.slot"
import wrapping_, Mixin from  require "util"

vector = Vector!

export DIALOGUE

class Dialogue
  new: (@script) =>

  clear: =>
    for name, slot in pairs Slot.INSTANCES
      slot\clear!

  start: (slots={}) =>
    @routine = coroutine.create @script

    @clear!
    for name, slot in pairs Slot.INSTANCES
      slots[name] = slot

    DIALOGUE = @

    coroutine.resume @routine, slots

    if "dead" == coroutine.status @routine
      DIALOGUE = nil

  next: (...) =>
    @clear!

    coroutine.resume @routine, ...

    if "dead" == coroutine.status @routine
      DIALOGUE = nil

clickable_dialogue = (dialogue) ->
  wrapping_ class ReceptionDialogue extends Mixin
    new: (scene) =>
      super!

      points = {}
      for point in *@mask.paths[1]
        points[#points+1] =  point.cp.x
        points[#points+1] =  point.cp.y

      @hitarea = scene.hit\polygon unpack points
      @hitarea.mousepressed = @\mousepressed
      @hitarea.prio = 0

      local player, slot
      for layer in *@
        if layer.name == "player"
          player = layer
        elseif layer.name\match "slot%(%)"
          @slot = layer

      @playerpos = vector.clone player.mask.paths[1][1].cp
      @playerdir = vector.clone(player.mask.paths[1][2].cp) - @playerpos

    mousepressed: =>
      player = SCENE.tags.player
      player\moveTo SCENE\unproject_3d(@playerpos), ->
        player.sheet.last = player.sheet\get @playerdir\normalized!
        dialogue\start player: @slot

    draw: (draw_group, draw_layer) =>
      draw_group { @slot }

{
  :Dialogue
  :clickable_dialogue
}
