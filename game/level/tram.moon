import wrapping_, Mixin from  require "util"

wrapping_ class SubAnim extends Mixin
  SPEED = 120
  new: (@frametime=0.1) =>
    super!

    @pos = 0

  update: (dt) =>
    @pos = (@pos + SPEED*dt) % WIDTH

  draw: (recursive_draw) =>
    love.graphics.draw @image, @pos/4 - @ox - 120, -@oy
