import Dialogue from require "game.dialogue"
import wrapping_, Mixin from  require "util"

reception_dialogue = Dialogue =>
  @receptionist\say "hey, what do you need?"
  @other\say "nothing, you just suck man"
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

  mousepressed: =>
    reception_dialogue\start!
