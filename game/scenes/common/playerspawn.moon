import wrapping_, Mixin from  require "util"
import Player from require "game.player"
Vector = require "lib.hump.vector"

wrapping_ class PlayerSpawn extends Mixin
  new: (scene, @skin, lscene) =>
    if lscene and (not SCENE or not SCENE.last_scene or not lscene\match SCENE.last_scene)
      print "nopeing: #{lscene}"
      @draw = ->
      @update = ->
      return

    super!

    point = @mask.paths[1][1]
    pos = Vector point.cp.x, point.cp.y
    @player = Player scene, @skin, scene\unproject_3d pos

    scene.tags.player = @player

  update: (dt) =>
    @player\update dt

  draw: =>
    @player\draw!
