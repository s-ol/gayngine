artal = require "lib.artal.artal"

ALL_SHEETS = setmetatable {}, __mode: 'v'
RECHECK = 0.3

class PSDSheet
  new: (@filename, @frametime=.1) =>
    @time   = 0
    @frame  = 1

    @reload!

    if WATCHER
      WATCHER\register @filename, @

  reload: =>
    print "reloading #{@filename}..."


    @frames = {}
    target = @frames
    local group

    psd = artal.newPSD @filename
    for layer in *psd
      if layer.type == "open"
        if not group
          layer.image = love.graphics.newCanvas psd.width, psd.height
          love.graphics.setCanvas layer.image
          table.insert target, layer
          group = layer.name
      elseif layer.type == "close"
        if layer.name == group
          love.graphics.setCanvas!
          group = nil
      else
        if not group
          table.insert target, layer
        else
          love.graphics.draw layer.image, -layer.ox, -layer.oy if layer.image

  update: (dt) =>
    @time += dt

    @frame = 1 + (math.floor(@time/@frametime) % #@frames)

  draw: (x, y, rot) =>
    {:image, :ox, :oy} = @frames[@frame]
    love.graphics.draw image, x, y, rot, nil, nil, ox, oy if image

{
  :PSDSheet,
}
