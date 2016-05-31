import PSDSheet from require "psdsheet"
Vector = require "lib.hump.vector"

ORIGIN = Vector 0, 40

class Player extends PSDSheet
  new: (@skin, @pos=Vector!) =>
    super "game/characters/#{@skin}.psd"

  draw: =>
    { :x, :y } = @pos - ORIGIN
    super\draw x, y

{
  :Player,
}
