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

    _, mixin = pcall require, "game.common.#{name}"
    return mixin if not _ and mixin

    _, module = pcall require, "game.common"
    return module[name] if _ and module[name]

    LOG_ERROR "couldn't find mixin '#{name}' for scene '#{@scene}'"
    nil

  reload: (filename) =>
    filename = "assets/#{@scene}.psd" unless filename
    print "reloading scene #{filename}..."

    @tree, @tags = {}, {}
    target = @tree
    local group

    indent = 0

    psd = artal.newPSD filename
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

      cmd, params = layer.name\match "^([^:]+):(.+)"
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
          LOG "loading mixin '#{@scene}/#{name}' (#{table.concat params, ", "})", indent
          mixin layer, unpack params
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

  draw: (group=@tree) =>
    if group == false
      return
    elseif group == @tree
      love.graphics.scale 4

    for layer in *group
      if layer.draw
        layer\draw @\draw
      elseif layer.image
        {:image, :ox, :oy} = layer
        love.graphics.setColor 255, 255, 255, layer.opacity or 255
        love.graphics.draw image, x, y, nil, nil, nil, ox, oy
      elseif layer.type == "open"
        @draw layer

{
  :PSDScene,
}
