{ graphics: lg, keyboard: lk } = love

Vector = require "lib.hump.vector"

class DebugMenu
  new: =>
    @enabled = not _BUILD

    @proxy = setmetatable {},
      __index: (key) => @[key] = false

    @DEBUG = setmetatable {},
      __call: (_, tgl) ->
        @enabled
      __newindex: @proxy
      __index: (_, key) ->
        if @enabled
          @proxy[key]
        else
          false

    @lasth = 0

  keypressed: (key) =>
    if not @enabled
      return unless key == "d" and lk.isDown "lshift"
    switch key
      when "d"
        @enabled = not @enabled
      when "r"
        SCENE\reload! if @enabled
      when "right"
        SCENE.scroll += Vector 4, 0 if DEBUG!
      when "left"
        SCENE.scroll -= Vector 4, 0 if DEBUG!
      else
        if @enabled
          for name, value in pairs @proxy
            if key == name\sub 1, 1
              @proxy[name] = not value
              break

  draw: =>
    return unless @enabled

    y = 0

    lg.setColor 0, 0, 0, 120
    lg.rectangle "fill", 5, 5, 150, @lasth
    y += 5

    lg.setColor 255, 255, 255

    lg.print "[D]EBUG", 8, y
    lg.line 5, y+13, 155, y+13
    y += 15

    lg.print "DIALOGUE: #{DIALOGUE}", 10, y
    lg.setColor 255, 255, 255, 120
    lg.line 10, y+13, 150, y+13
    y += 15

    for option, enabled in pairs @proxy
      key, rest = option\sub(1, 1), option\sub 2
      status = if enabled then "on" else "off"

      lg.setColor 255, 255, 255, if enabled then 255 else 180
      lg.print "[#{key}]#{rest}: #{status}", 10, y
      y += 10

    lg.setColor 255, 255, 255, 120
    lg.line 10, y+3, 150, y+3
    y += 5

    lg.setColor 255, 255, 255
    for control in *{"reload", "< left", "> right"}
      key, rest = control\sub(1, 1), control\sub 2

      lg.print "[#{key}]#{rest}", 10, y
      y += 10

    @lasth = y

{
  :DebugMenu,
}
