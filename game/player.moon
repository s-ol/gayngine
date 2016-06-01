import PSDSheet from require "psdsheet"
import Reloadable from require "util"
Vector = require "lib.hump.vector"

class Player extends Reloadable
  ORIGIN = Vector 16, 65
  SPEED = 120
  new: (@scene, @skin, @pos=Vector!) =>
    super!

    @sheet = PSDSheet "game/characters/#{@skin}.psd"

  reload: (...) =>
    new = super ...

    setmetatable @, new.Player.__base

  update: (dt) =>
    @sheet\update dt

    if @goal
      delta = @goal - @pos
      if delta\len2! < .01
        @goal = nil

      @pos += delta\trimmed dt * SPEED

  draw: =>
    { :x, :y } = @scene\project_3d(@pos) - ORIGIN
    @sheet\draw math.floor(x), math.floor(y)

  moveTo: (x, y) =>
    @goal = Vector x, y

{
  :Player,
}
