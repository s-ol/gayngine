import wrapping_, Mixin from  require "util"
Vector = require "lib.hump.vector"

wrapping_ class PlayerSpawn extends Mixin
  new: (scene) =>
    super!

    point = @mask.paths[1][1].cp
    @limit = SCENE\unproject_3d(Vector point.x, point.y).y

  update: (dt) =>
    @player = SCENE.tags.player if not @player

    @player.hidden = @player.pos.y <= @limit

  draw: =>
    @player\draw false
