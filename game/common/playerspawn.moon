import wrapping_, Mixin from  require "util"
import Player from require "game.common.player"
Vector = require "lib.hump.vector"

wrapping_ class PlayerSpawn extends Mixin
  new: (scene, @skin) =>
    super!

    pos = Vector math.floor(@image\getWidth!/2) - @ox, math.floor(@image\getHeight!/2) - @oy
    @player = Player @skin, pos

  update: (dt) =>
    @player\update dt

  draw: =>
    @player\draw!
