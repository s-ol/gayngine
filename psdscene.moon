{ graphics: lg, mouse: lm } = love

artal = require "lib.artal.artal"
psshaders = require "shaders"
Vector = require "lib.hump.vector"
HC = require "lib.HC"

SCALE = tonumber arg[3] or 4
KEYHOLE = lg.getWidth! * 0.2

hand = lm.getSystemCursor "hand"
arrow = lm.getSystemCursor "arrow"

export DIALOGUE

class PSDScene
  new: (@scene) =>
    @hit = HC.new!
    @cursor = HC.point 0, 0
    @scroll = Vector!
    @state = {}

    @reload!

    if WATCHER
      WATCHER\register @filename!, @

  transition_to: (next_scene) =>
    @last_scene = @scene
    @scene = next_scene
    DIALOGUE = nil
    @reload!
    @init!

  filename: =>
    scene, subscene = @scene\match "([a-zA-Z-_]+)%.([a-zA-Z-_]+)"
    if scene and subscene
      "game/scenes/#{scene}/#{subscene}.psd"
    else
      "game/scenes/#{@scene}/main.psd"

  init: =>
    scene, subscene = @scene\match "([a-zA-Z-_]+)%.([a-zA-Z-_]+)"

    _, module = pcall require, "game.scenes.#{scene or @scene}"
    if _ and type(module) == "table" and module.init
      print "running init for #{@scene}..."
      module.init @

  load: (name, ...) =>
    scene = @scene
    if rscene = scene\match "([a-zA-Z-_]+)%.([a-zA-Z-_]+)"
      scene = rscene

    _, mixin = pcall require, "game.scenes.#{scene}.#{name}"
    return mixin if _ and mixin

    --_, module = pcall require, "game.scenes.#{scene}"
    --return module[name] if _ and module[name]

    _, mixin = pcall require, "game.scenes.common.#{name}"
    return mixin if _ and mixin

    _, module = pcall require, "game.scenes.common"
    return module[name] if _ and module[name]

    LOG_ERROR "couldn't find mixin '#{name}' for scene '#{@scene}'"
    nil

  reload: (filename) =>
    filename = filename or @filename!
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

  unproject_2d: (vec) => vec / SCALE + @scroll
  project_2d: (vec) => (vec - @scroll) * SCALE

  unproject_3d: (vec) =>
    --Vector vec.x - vec.y, 2*vec.y
    vec\permul Vector 1, 3

  project_3d: (vec) =>
    --x_offset = vec.y/2
    --Vector vec.x + vec.y/2, vec.y/2
    vec\permul Vector 1, 1/3

  update: (dt) =>
    @update_group dt, @tree

    if @tags.player
      pos = @tags.player.pos
      keyhole_right = (Vector (WIDTH + KEYHOLE) / 2, 0) / SCALE
      keyhole_left = (Vector (WIDTH - KEYHOLE) / 2, 0) / SCALE
      if pos > @scroll + keyhole_right
        @scroll.x = (pos - keyhole_right).x
      elseif pos < @scroll + keyhole_left
        @scroll.x = (pos - keyhole_left).x

    mouse = @unproject_2d Vector lm.getPosition!
    @cursor\moveTo mouse\unpack!
    @hoveritems = @hit\collisions @cursor
    if next @hoveritems
      lm.setCursor hand
    else
      lm.setCursor arrow

  mousepressed: (x, y, btn) =>
    mouse = @unproject_2d Vector x, y

    if btn == 1
      @cursor\moveTo mouse.x, mouse.y

      items = @hit\collisions @cursor

      shapes = [shape for shape, _ in pairs items]
      table.sort shapes, (a, b) -> a.prio > b.prio
      for shape in *shapes
        shape\mousepressed x, y, btn if shape.mousepressed
        break
    elseif btn == 2 and @tags.player
      if not DIALOGUE
        @tags.player\moveTo @unproject_3d mouse

  update_group: (dt, group) =>
    return unless group

    for layer in *group
      if layer.update
        layer\update dt, @\update_group
      elseif layer.type == "open"
        @update_group dt, layer

  draw: =>
    lg.setCanvas @target_canvas
    lg.clear!
    lg.setCanvas!

    @draw_group @tree

    lg.push!
    lg.scale SCALE
    lg.setColor 255, 255, 255
    lg.translate -@scroll.x, -@scroll.y
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
