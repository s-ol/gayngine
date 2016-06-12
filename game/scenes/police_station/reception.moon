Vector = require "lib.hump.vector"
Slot = require "game.scenes.common.slot"
import Dialogue from require "game.dialogue"
import wrapping_, Mixin from  require "util"

vector = Vector!

reception_dialogue = Dialogue =>
  @receptionist\say "hey, what do you need?"
  @player\say "nothing, you just suck man"
  @receptionist\say "cmon, don't be like that...."

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
    SCENE.tags.player\moveTo SCENE\unproject_3d(@playerpos), ->
      -- TODO: turn to @playerdir
      reception_dialogue\start player: @slot

  draw: (draw_group, draw_layer) =>
    draw_group { @slot }
