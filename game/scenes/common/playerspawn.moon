import wrapping_, Mixin from  require "util"
import Player from require "game.player"
Vector = require "lib.hump.vector"

wrapping_ class PlayerSpawn extends Mixin
  new: (scene, @skin, last_scene) =>
    super!

    print "-----adding '#{last_scene or ""}'"

    scene.tags.spawns = scene.tags.spawns or {}
    scene.tags.spawns[last_scene or ""] = @

  init: =>
    point = @mask.paths[1][1]
    pos = Vector point.cp.x, point.cp.y
    @player = Player SCENE, @skin, SCENE\unproject_3d pos

    SCENE.tags.player = @player

  update: (dt) =>
    @player\update dt if @player

  draw: =>
    @player\draw! if @player
