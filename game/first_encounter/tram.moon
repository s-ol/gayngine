import wrapping_, Mixin from  require "util"

wrapping_ class SubAnim extends Mixin
  SPEED = 440
  new: (scene) =>
    super!

    @pos = 0

  update: (dt) =>
    @pos = (@pos + SPEED*dt) % (WIDTH*2)

  draw: (recursive_draw) =>
    love.graphics.draw @image, @pos/4 - @ox - 140, -@oy
