import wrapping_, Mixin from  require "util"
import MultiSheet from require "psdsheet"
import ORIGIN, SPEED from require "game.player"
Vector = require "lib.hump.vector"

wrapping_ class PlayerSpawn extends Mixin
  new: (scene) =>
    super!

    point = @mask.paths[1][1]
    @pos = SCENE\unproject_3d Vector point.cp.x, point.cp.y
    @sheet = MultiSheet "game/characters/hector.psd", .15

    @path = for point in *@mask.paths[1]
      SCENE\unproject_3d Vector point.cp.x, point.cp.y
    @index = 2

  update: (dt) =>
    total = Vector!

    travel_dist = dt * SPEED

    while @path[@index]
      goal = @path[@index]
      delta = goal - @pos

      if delta\len! <= travel_dist
        travel_dist -= delta\len!
        @index += 1
        @pos = goal
        total += delta
      else
        delta = delta\trimmed travel_dist
        @pos += delta
        total += delta
        break

    @sheet\update total, dt

  draw: =>
    { :x, :y } = SCENE\project_3d(@pos) - ORIGIN
    @sheet\draw math.floor(x), math.floor y
