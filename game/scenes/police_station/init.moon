import Dialogue from require "game.dialogue"

main = Dialogue =>
  @lieutenant\say "test test test"

{
  init: =>
    if @last_scene
      for pattern, spawn in pairs @tags.spawns
        if @last_scene\match pattern
          spawn\init!
          break
    else
      k, v = next @tags.spawns
      v\init!
}
