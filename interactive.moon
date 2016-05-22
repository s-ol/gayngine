{graphics: lg} = love

class Interactive
  new: (@pos, @poly) =>
    --GAME_WORLD.Cpolygon unpack @poly
    --GAME_WORLD.circle @pos.x, @pos.y, 50

  click: (x, y) =>
    if @menu
      return
    else
      @menu = {
        "Pick up",
        "Examine"
      }

  draw: =>
    lg.circle "fill", @pos.x, @pos.y, 50
    if @menu
      lg.push!
      lg.translate  @pos.x + 20, @pos.y - 12

      lg.setColor 52, 52, 52
      lg.rectangle "fill", -4, -4, 150, #@menu * 18 + 4

      lg.setColor 255, 255, 255
      for action in *@menu
        lg.print action
        lg.translate 0, 18

      lg.pop!

{
  :Interactive
}
