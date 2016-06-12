Vector = require "lib.hump.vector"
import Dialogue from require "game.dialogue"
import wrapping_, Mixin from  require "util"

vector = Vector!

reception_dialogue = Dialogue =>

  ray = @raymond_reception

  @receptionist\say "hey, what do you need?"
  ray\say "nothing, you just suck man"
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

    @playerpos = vector.clone @[1].mask.paths[1][1].cp
    @playerdir = vector.clone(@[1].mask.paths[1][2].cp) - @playerpos

  mousepressed: =>
    SCENE.tags.player\moveTo SCENE\unproject_3d(@playerpos), ->
      -- TODO: turn to @playerdir
      reception_dialogue\start!

  draw: =>
