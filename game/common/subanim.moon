import wrapping_ from  require "util"

wrapping_ class SubAnim
  new: (@frametime=0.1) =>
    @time = 0
    @frame = 1

  update: (dt) =>
    @time += dt

    @frame = 1 + (math.floor(@time/@frametime) % #@)

  draw: (recursive_draw) =>
    recursive_draw {@[@frame]}
