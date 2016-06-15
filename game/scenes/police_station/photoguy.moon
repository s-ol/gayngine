import wrapping_, Mixin from  require "util"

wrapping_ class Photoguy extends Mixin
  new: (scene) =>
    super!

    for layer in *@
      if layer.name\match "idle"
        @idle = layer
      else
        @talking = layer

    @current = { @idle }

  draw: (draw_group, draw_layer) =>
    draw_group { @current }

  update: (dt, update_group) =>
    @current = if SCENE.state.photoguy then @talking else @idle

    @current\update dt if @current.update

