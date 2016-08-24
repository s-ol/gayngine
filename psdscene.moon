{ graphics: lg, mouse: lm, filesystem: lf } = love

artal = require "lib.artal.artal"
psshaders = require "shaders"
Vector = require "lib.hump.vector"
HC = require "lib.HC"

SCALE = 4
KEYHOLE = lg.getWidth! * 0.2
TRANSITION_TIME = 2

cursor = lm.newCursor "assets/cursor_hand.png", 11, 1
cursor_clicked = lm.newCursor "assets/cursor_hand_clicked.png", 11, 1
cursor_hover = lm.newCursor "assets/cursor_hand_hover.png", 11, 1

export DIALOGUE, SCENE

class PSDScene
  new: (@scene) =>
    SCENE = @

    @cursor = HC.point 0, 0
    @state = {}

    @reload!

    if WATCHER
      WATCHER\register @filename!, @

  transition_to: (next_scene, transition_time=TRANSITION_TIME, nomute) =>
    @no_mute = nomute
    @next_scene = next_scene
    @transition_time = 1
    @transition_speed = transition_time/TRANSITION_TIME

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

  load: (name) =>
    scene = @scene
    if rscene = scene\match "([a-zA-Z-_]+)%.([a-zA-Z-_]+)"
      scene = rscene

    try_load = (name) ->
      if (lf.exists "game/scenes/#{name}.lua") or
        (lf.exists "game/scenes/#{name}.moon") or
        (lf.exists "game/scenes/#{name}/init.lua") or
        (lf.exists "game/scenes/#{name}/init.moon")
        status, module = pcall require, "game.scenes.#{name\gsub "/", "."}"

        select 2, DEBUG\assert status, module

    if mixin = try_load "#{scene}/#{name}"
      return mixin

    if module = try_load "#{scene}"
      return module[name] if module[name]

    if mixin = try_load "common/#{name}"
      return mixin

    if module = try_load "common"
      return module[name] if module[name]

    DEBUG\warn "couldn't find mixin '#{name}' for scene '#{@scene}'"
    nil

  reload: (filename) =>
    filename = filename or @filename!
    print "reloading scene #{filename}..."

    @scroll = Vector!
    @hit = HC.new!
    @tree, @instances, @tags = {}, {}, {}
    target = @tree
    local group

    indent = 0

    psd = artal.newPSD filename
    @width, @height = psd.width, psd.height

    @target_canvas = lg.newCanvas @width, @height
    @source_canvas = lg.newCanvas @width, @height


    log_indented = (indent, text) -> DEBUG\log " "\rep(indent) .. text, 1

    for layer in *psd
      if layer.type == "open"
        table.insert target, layer
        layer.parent = target
        target = layer
        log_indented indent, "+ #{layer.name}"
        indent += 1
        continue -- skip until close
      elseif layer.type == "close"
        target.mask = layer.mask
        layer = target
        target = target.parent
        indent -= 1
      else
        log_indented indent, "- #{layer.name}"
        table.insert target, layer

      for name, params in layer.name\gmatch "([a-z]+)%((.-)%)"
        params = [str for str in params\gmatch "[^,]+"]

        mixin = @load name
        if mixin
          log_indented indent, "  > loading mixin '#{@scene}/#{name}' (#{table.concat params, ", "})"
          mixin layer, @, unpack params
          @instances[name] or= {}
          table.insert @instances[name], layer

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
    scene, subscene = @scene\match "([a-zA-Z-_]+)%.([a-zA-Z-_]+)"

    _, module = pcall require, "game.scenes.#{scene or @scene}"
    if _ and type(module) == "table" and module.update
      module.update @, dt


    if @transition_time
      tdt = dt / @transition_speed
      @transition_time -= tdt
      if @transition_time + tdt > 0 and @transition_time < 0
        @last_scene, @scene, @next_scene = @scene, @next_scene
        DIALOGUE = nil
        SOUND\stop @scene
        @reload!
        @init!
      elseif @transition_time <= -1
        @transition_time = nil

      SOUND\setVolume math.max(0, math.abs(@transition_time or 1) - .3) / .7 unless @no_mute
    SOUND\setPosition @scroll + .5 * Vector 320, 180

    @update_group dt, @tree

    local controlled_by_path
    for path in *(@instances.camerapath or {})
      if path.active
        @scroll = path\apply @scroll
        controlled_by_path = true

    if not controlled_by_path and @tags.player
      pos = @tags.player.pos
      keyhole_right = (Vector (WIDTH + KEYHOLE) / 2, 0) / SCALE
      keyhole_left = (Vector (WIDTH - KEYHOLE) / 2, 0) / SCALE
      if pos > @scroll + keyhole_right
        @scroll.x = (pos - keyhole_right).x
      elseif pos < @scroll + keyhole_left
        @scroll.x = (pos - keyhole_left).x

      @scroll.x = math.max 0, math.min @scroll.x, @width - WIDTH/SCALE

    mouse = @unproject_2d Vector lm.getPosition!
    @cursor\moveTo mouse\unpack!
    @hoveritems = @hit\collisions @cursor
    if lm.isDown 1
      lm.setCursor cursor_clicked
    elseif next @hoveritems
      lm.setCursor cursor_hover
    else
      lm.setCursor cursor

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

  keypressed: (key) =>
    if @tags.player and not DIALOGUE
      print

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
    fade = math.max 0, math.abs(@transition_time or 1) - .3
    lg.setColor 255, 255, 255, fade * 255 / (1 - .3)
    lg.translate -@scroll.x, -@scroll.y
    lg.draw @target_canvas

    if DEBUG.tools.hitboxes
      lg.setColor 255, 255, 0, 120
      for shape,_ in pairs @hit.hash\shapes!
        shape\draw "line"
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
        layer\draw @\draw_group, @\draw_layer, DEBUG.selected_node == layer
        lg.setCanvas!
      elseif layer.image
        @draw_layer layer
      elseif layer.type == "open"
        @draw_group layer

{
  :PSDScene,
}
