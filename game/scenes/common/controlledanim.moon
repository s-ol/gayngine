import wrapping_, Mixin from  require "util"

wrapping_ class ControlledAnim extends Mixin
  new: (scene, @key) =>
    super!

    for layer in *@
      if layer.name\match "idle"
        @idle = layer
      else
        @talking = layer

  draw: (draw_group, draw_layer) =>
    draw_group { @current }

  update: (dt, update_group) =>
    name = SCENE.state[@key] or "idle"
    for child in *@
      if child.name\match "^#{name}"
        @current = child
        break

    @current\update dt if @current and @current.update
