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
    target = @anims
    local group

    psd = artal.newPSD @filename
    for layer in *psd
      if layer.type == "open"
        if not group
          group = layer.name
          layer.image = love.graphics.newCanvas psd.width, psd.height
          love.graphics.setCanvas layer.image
          @frames[group] = layer
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
    love.graphics.setColor 255, 255, 255
    love.graphics.draw image, x, y, rot, nil, nil, ox, oy if image

class MultiSheet
  new: (@filename, @frametime=.1) =>
    @time   = 0
    @frame  = 1
    @anim = "idle"

    @reload!

    if WATCHER
      WATCHER\register @filename, @

  reload: =>
    print "reloading #{@filename}..."

    @anims = {}
    local anim

    psd = artal.newPSD @filename
    for layer in *psd
      if not anim
        name = layer.name
        if layer.type == "open"
          anim = layer.name
        else
          layer = { layer }

        @anims[name] = layer
      else
        if layer.type == "close"
          anim = nil
        else
          table.insert @anims[anim], layer

  get: (vec) =>
    if vec\len2! < .1
      "idle" .. (@last or "right")
    else
      @last = if vec.x > 0
        "right"
      else
        "left"
      @last

  update: (vec, dt) =>
    new = @get vec/dt
    if new != @anim
      @time = 0
      @anim = new

    return unless @anims[@anim]

    if @anim\match "idle"
      dt /= 4

    @time += dt

    @frame = 1 + (math.floor(@time/@frametime) % #@anims[@anim])

  draw: (x, y, rot) =>
    return unless @anims[@anim]

    {:image, :ox, :oy} = @anims[@anim][@frame]

    love.graphics.setColor 255, 255, 255
    love.graphics.draw image, x, y, rot, nil, nil, ox, oy if image

{
  :PSDSheet,
  :MultiSheet,
}
