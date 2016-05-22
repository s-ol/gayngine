artal = require "lib.artal.artal"

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

    _, mixin = pcall require, "game.shared.#{name}"
    return mixin if _ and mixin

    _, module = pcall require, "game.shared"
    return module[name] if _ and module[name]

    LOG_ERROR "couldn't find mixin '#{name}' for scene #{@scene}"
    ->

  reload: (filename) =>
    filename = "assets/#{@scene}.psd" unless filename
    print "reloading scene #{filename}..."

    @tree, @layers = {}, {}
    target = @tree
    local group

    level = 0

    psd = artal.newPSD filename
    for layer in *psd
      if layer.type == "open"
        table.insert target, layer
        layer.parent = target
        target = layer
        print "#{" "\rep level}+ #{layer.name}"
        level += 1
      elseif layer.type == "close"
        target = target.parent
        level -= 1
        continue -- skip loading
      else
        print "#{" "\rep level}- #{layer.name}"
        table.insert target, layer

      cmd, params = layer.name\match "^([^:]+):(.+)"
      switch cmd
        when nil
          ""
        when "layer"
          @layers[params] = layer
        when "load"
          params = [str for str in params\gmatch "[^,]+"]
          name = table.remove params, 1
          --name, r, rest = params\match "^([^,]+)(,(.+))?"
          --print params, ".", name, r, rest

          --parameters = {}
          --param, rest = rest\match "^([^,]+),(.+)"
          --while param
          --  table.insert parameters, param
          --  param, rest = rest\match "^([^,]+),(.+)"

          mixin = @load name
          print "loading mixin '#{@scene}/#{name}' for layer '#{layer.name}' (#{table.concat params, ", "})"
          mixin layer, unpack params
        else
          LOG_ERROR "unknown cmd '#{cmd}' for layer '#{layer.name}'"

    require "moon.all"
    p @tree

  update: (dt) =>

  draw: (group=@tree) =>
    love.graphics.scale 4 if group == @tree
    for layer in *group
      if layer.draw
        layer\draw!
      elseif layer.image
        {:image, :ox, :oy} = layer
        love.graphics.draw image, x, y, nil, nil, nil, ox, oy
      elseif layer.type == "open"
        @draw layer unless layer.name == "puddles"

{
  :PSDScene,
}
