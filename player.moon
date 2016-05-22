{ graphics: lg } = love

Vector = require "lib.hump.vector"
import PSDSheet from require "psdsheet"

class Player
  WALK_VEL = 250
  new: (x, y, @skin) =>
    if y
      @pos = Vector x, y
    elseif x
      @pos = x

    --@sprite = PSDSheet @skin

  goto: (target) =>
    @target = target

  update: (dt) =>
    if @target
      delta = @target - @pos
      if delta\len2! > 1
        @pos += delta\trimmed dt * WALK_VEL
      else
        @target = nil
    --@sprite\update dt

  draw: =>
    lg.setColor 255, 255, 255
    -- @sprite\draw @pos
    {:x, :y} = @pos\permul PROJ
    lg.rectangle "fill", x-10, y-80, 20, 80


{
  :Player
}
