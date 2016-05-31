import wrapping_, Mixin from  require "util"

wrapping_ class SubAnim extends Mixin
  new: (scene, @frametime=0.1) =>
    super!

    @time = 0
    @frame = 1

  update: (dt) =>
    @time += dt

    @frame = 1 + (math.floor(@time/@frametime) % #@)

  draw: (draw_group, draw_layer) =>
    draw_group {@[@frame]}
