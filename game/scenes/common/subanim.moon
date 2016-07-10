import wrapping_, Mixin from  require "util"

wrapping_ class SubAnim extends Mixin
  new: (scene, @frametime=0.1, once="no") =>
    super!

    @time = 0
    @frame = 1
    @frametime = tonumber @frametime

    if once == "once" then @once = true

  update: (dt) =>
    @time += dt

    @frame = 1 + (math.floor(@time/@frametime) % #@)

    if @time >= @frametime * #@ and @once
      @frame = #@
      @update = ->

  draw: (draw_group, draw_layer) =>
    draw_group {@[@frame]}
