{ graphics: lg } = love

artal = require "lib.artal.artal"
psshaders = require "shaders"

class PSDScene
  new: (@scene) =>
    @reload!

    if WATCHER
      WATCHER\register "assets/#{@scene}.psd", @

  load: (name, ...) =>
    _, mixin = pcall require, "game.#{@scene}.#{name}"
    return mixin if _ and mixin

    _, module = pcall require, "game.#{scene}"
    return module[name] if _ and module[name]

    _, mixin = pcall require, "game.common.#{name}"
    return mixin if _ and mixin

    _, module = pcall require, "game.common"
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


  reload: (filename) =>
    filename = "assets/#{@scene}.psd" unless filename
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
        layer = target
        target = target.parent
        indent -= 1
      else
        LOG "- #{layer.name}", indent
        table.insert target, layer

      cmd, params = layer.name\match "([^: ]+):(.+)"
      switch cmd
        when nil
          ""
        when "tag"
          @tags[params] = tag
          layer.tag = params
        when "load"
          params = [str for str in params\gmatch "[^,]+"]
          name = table.remove params, 1

          mixin = @load name
          if mixin
            LOG "loading mixin '#{@scene}/#{name}' (#{table.concat params, ", "})", indent
            mixin layer, unpack params
          else
            LOG_ERROR "couln't find mixin for '#{@scene}/#{name}'", indent
        else
          LOG_ERROR "unknown cmd '#{cmd}' for layer '#{layer.name}'", indent

  update: (dt, group=@tree) =>
    if group == false
      return

    for layer in *group
      if layer.update
        layer\update dt, @\update
      elseif layer.type == "open"
        @update dt, layer

  i = 0
  draw: () =>
    lg.setCanvas @target_canvas
    lg.clear!
    lg.setCanvas!

    i = 0
    @drawgroup @tree

    lg.push!
    lg.scale 4
    lg.draw @target_canvas
    lg.pop!

  _canvas = nil
  _blendmode = nil

  setup_shader: (blendmode, opacity, image, ox, oy) =>
    @target_canvas, @source_canvas = @source_canvas, @target_canvas
    _canvas = lg.getCanvas!
    _blendmode = lg.getBlendMode!

    lg.setCanvas!
    lg.setShader!
    lg.draw @source_canvas, 800, i*200

    lg.setCanvas @target_canvas
    lg.setBlendMode "replace", "premultiplied"

    shader = psshaders[blendmode]
    pcall shader.send, shader, "opacity", opacity/255
--    pcall shader.send, shader, "background", @source_canvas
--    pcall shader.send, shader, "background_size", { @source_canvas\getDimensions! }
    image\setWrap "clampzero", "clampzero"
    pcall shader.send, shader, "foreground", image
    pcall shader.send, shader, "foreground_size", { image\getDimensions! }
    pcall shader.send, shader, "foreground_offset", { ox, oy }

    lg.setShader shader

    lg.draw @source_canvas

  teardown_shader: =>
    lg.setShader!
    lg.setCanvas _canvas
    lg.setBlendMode _blendmode
    lg.draw @source_canvas, 1000, i*200

  drawgroup: (group) =>
    if group == false
      return

    for layer in *group
      if layer.draw
        layer\draw @\drawgroup
      elseif layer.image
        {:image, :blend, :opacity, :ox, :oy} = layer

        i += 1
        @setup_shader blend, opacity, image, ox, oy
        --lg.draw image, -ox, -oy
        @teardown_shader!

      elseif layer.type == "open"
        @drawgroup layer

{
  :PSDScene,
}
