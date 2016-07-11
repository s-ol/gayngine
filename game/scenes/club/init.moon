import Dialogue from require "game.dialogue"

{
  init: =>
    if @last_scene
      for spawn in *@instances.playerspawn
        if @last_scene\match spawn.pattern
          spawn\start!
          break
    else
      @instances.playerspawn[1]\start!
}
