{ graphics: lg, mouse: lm } = love

artal = require "lib.artal.artal"
psshaders = require "shaders"
Vector = require "lib.hump.vector"
HC = require "lib.HC"

SCALE = 4

class PSDScene
  new: (@scene) =>
    @hit = HC.new!
    @cursor = HC.point 0, 0
    @scroll = Vector!

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

      for name, params in layer.name\gmatch "([a-z]+)%((.-)%)"
        params = [str for str in params\gmatch "[^,]+"]

        mixin = @load name
        if mixin
          LOG "loading mixin '#{@scene}/#{name}' (#{table.concat params, ", "})", indent
          mixin layer, @, unpack params

      --name, params = layer.name\gmatch "([a-z]+)%((.*)%)"
      --if name
      --  params = [str for str in params\gmatch "[^,]+"]

      --  mixin = @load name
      --  if mixin
      --    LOG "loading mixin '#{@scene}/#{name}' (#{table.concat params, ", "})", indent
      --    mixin layer, @, unpack params

  unproject_2d: (vec) => vec / SCALE - @scroll
  project_2d: (vec) => (vec + @scroll) * SCALE

  unproject_3d: (vec) =>
    Vector vec.x - vec.y, 2*vec.y

  project_3d: (vec) =>
    x_offset = vec.y/2
    Vector vec.x + vec.y/2, vec.y/2

  update: (dt) =>
    @update_group dt, @tree

    mouse = @unproject_2d Vector lm.getPosition!
    @cursor\moveTo mouse\unpack!
    @hoveritems = @hit\collisions @cursor

  mousepressed: (x, y, btn) =>
    mouse = @unproject_2d Vector x, y

    if btn == 1
      @cursor\moveTo mouse.x, mouse.y

      items = @hit\collisions @cursor
      for shape, _ in pairs items
        shape\mousepressed x, y, btn if shape.mousepressed
    elseif btn == 2
      mouse = @unproject_3d mouse
      @tags.player\moveTo mouse.x, mouse.y

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
    lg.scale SCALE
    lg.setColor 255, 255, 255
    lg.translate @scroll.x, @scroll.y
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

    lg.setColor 255, 255, 255
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
