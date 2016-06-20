{ graphics: lg } = love

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
    if key == "d"
      @enabled = not @enabled
    elseif @enabled
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

    @lasth = y

{
  :DebugMenu,
}
