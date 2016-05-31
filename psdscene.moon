{ graphics: lg, mouse: lm } = love

artal = require "lib.artal.artal"
psshaders = require "shaders"
Vector = require "lib.hump.vector"
HC = require "lib.HC"

class PSDScene
  new: (@scene) =>
    @hit = HC.new!
    @cursor = HC.point 0, 0

    @init!

    @reload!

    if WATCHER
      WATCHER\register "game/scenes/#{@scene}/main.psd", @

  init: =>
    pcall require, "game.scenes.#{@scene}"

  load: (name, ...) =>
    _, mixin = pcall require, "game.scenes.#{@scene}.#{name}"
    return mixin if _ and mixin

    _, module = pcall require, "game.scenes.#{scene}"
    return module[name] if _ and module[name]

    _, mixin = pcall require, "game.scenes.common.#{name}"
    return mixin if _ and mixin

    _, module = pcall require, "game.scenes.common"
    return module[name] if _ and module[name]

    LOG_ERROR "couldn't find mixin '#{name}' for scene '#{@scene}'"
    nil

  draw_with_shader: (shader, ...) =>
    @target_canvas, @source_canvas = @source_canvas, @target_canvas

    lg.setCanvas @target_canvas
    lg.clear!

    lg.setShader shader
    shader\send "background", @source_canvas

    lg.draw ...
    lg.setShader!
    lg.setCanvas!

  find_tag: =>
    layer = @
    while not layer.tag
      layer = layer.parent

      if not layer
        return nil

    layer.tag

  reload: (filename) =>
    filename = "game/scenes/#{@scene}/main.psd" unless filename
    print "reloading scene #{filename}..."

    @tree, @tags = {}, {}
    target = @tree
    local group

    indent = 0

    psd = artal.newPSD filename
    @width, @height = psd.width, psd.height

    @target_canvas = lg.newCanvas @width, @height
    @source_canvas = lg.newCanvas @width, @height

    for layer in *psd
      if layer.type == "open"
        table.insert target, layer
        layer.parent = target
        target = layer
        LOG "+ #{layer.name}", indent
        indent += 1
        continue -- skip until close
      elseif layer.type == "close"
        target.mask = layer.mask
        layer = target
        target = target.parent
        indent -= 1
      else
        LOG "- #{layer.name}", indent
        table.insert target, layer

      name, params = layer.name\match "([a-z]+)%((.*)%)"
      if name
        params = [str for str in params\gmatch "[^,]+"]

        mixin = @load name
        if mixin
          LOG "loading mixin '#{@scene}/#{name}' (#{table.concat params, ", "})", indent
          mixin layer, @, unpack params

  update: (dt) =>
    @update_group dt, @tree

    mouse = 1/4 * Vector lm.getPosition!
    @cursor\moveTo mouse\unpack!
    @hoveritems = @hit\collisions @cursor

  mousepressed: (x, y, btn) =>
    @cursor\moveTo x/4, y/4
    items = @hit\collisions @cursor
    for shape, _ in pairs items
      shape\mousepressed x, y, btn if shape.mousepressed

 
  update_group: (dt, group) =>
    return unless group

    for layer in *group
      if layer.update
        layer\update dt, @\update
      elseif layer.type == "open"
        @update_group dt, layer

  draw: () =>
    lg.setCanvas @target_canvas
    lg.clear!
    lg.setCanvas!

    @draw_group @tree

    lg.push!
    lg.scale 4
    lg.draw @target_canvas
    lg.pop!

  _canvas = nil
  _blendmode = nil

  draw_layer: (layer) =>
    {:image, :blend, :opacity, :ox, :oy} = layer

    @target_canvas, @source_canvas = @source_canvas, @target_canvas
    _canvas = lg.getCanvas!
    _blendmode = lg.getBlendMode!

    lg.setCanvas!
    lg.setShader!

    lg.setCanvas @target_canvas
    lg.setBlendMode "replace", "premultiplied"

    image\setWrap "clampzero", "clampzero"
    shader = psshaders[blend]
    pcall shader.send, shader, "opacity", opacity/255
    pcall shader.send, shader, "foreground", image
    pcall shader.send, shader, "foreground_size", { image\getDimensions! }
    pcall shader.send, shader, "foreground_offset", { ox, oy }

    lg.setShader shader

    lg.draw @source_canvas

    lg.setShader!
    lg.setCanvas _canvas
    lg.setBlendMode _blendmode

  draw_group: (group) =>
    if group == false
      return

    for layer in *group
      if layer.draw
        lg.setCanvas @target_canvas
        layer\draw @\draw_group, @\draw_layer
        lg.setCanvas!
      elseif layer.image
        @draw_layer layer
      elseif layer.type == "open"
        @draw_group layer

{
  :PSDScene,
}
