import wrapping_, Mixin from  require "util"
import Player from require "game.player"
Vector = require "lib.hump.vector"

wrapping_ class PlayerSpawn extends Mixin
  new: (scene, @skin, @pattern="") =>
    super!

  start: =>
    point = @mask.paths[1][1]
    pos = Vector point.cp.x, point.cp.y
    @player = Player SCENE, @skin, SCENE\unproject_3d pos

    SCENE.tags.player = @player

  update: (dt) =>
    @player\update dt if @player

  draw: (_, _, debug) =>
    @player\draw! if @player
