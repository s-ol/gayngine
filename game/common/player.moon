import PSDSheet from require "psdsheet"
Vector = require "lib.hump.vector"

class Player extends PSDSheet
  new: (@skin, @pos=Vector!) =>
    --super "assets/#{@skin}.psd"

  update: =>
  draw: =>
    love.graphics.setColor 255, 0, 0
    love.graphics.circle "fill", @pos.x, @pos.y, 5

    love.graphics.setColor 255, 255, 255

{
  :Player,
}
