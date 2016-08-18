{ graphics: lg, keyboard: lk, filesystem: lf } = love

Vector = require "lib.hump.vector"

SCENES = {}

for dir in *lf.getDirectoryItems "game/scenes"
  if lf.isDirectory "game/scenes/#{dir}"
    for file in *lf.getDirectoryItems "game/scenes/#{dir}"
      if scene = file\match "(.*)%.psd$"
        table.insert SCENES, "#{dir}.#{scene}"

export DIALOGUE

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
        true
      when "r"
        SCENE\reload!
        SCENE\init!
        true
      when "s"
        if DIALOGUE
          DIALOGUE\clear!
          DIALOGUE = nil
        true
      when "l"
        @scene_chooser_index = 1
        true
      when "up"
        if @scene_chooser_index
          @scene_chooser_index = (@scene_chooser_index - 2) % #SCENES + 1
          true
        else
          false
      when "down"
        if @scene_chooser_index
          @scene_chooser_index = @scene_chooser_index % #SCENES + 1
          true
        else
          false
      when "escape"
        if @scene_chooser_index
          @scene_chooser_index = nil
          true
        else
          false
      when "return"
        if @scene_chooser_index
          SCENE\transition_to SCENES[@scene_chooser_index]
          @scene_chooser_index = nil
          true
        else
          false
      else
        for name, value in pairs @proxy
          if key == name\sub 1, 1
            @proxy[name] = not value
            return true
        false

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
    for control in *{"reload", "skip dialogue", "load scene"}
      key, rest = control\sub(1, 1), control\sub 2

      lg.print "[#{key}]#{rest}", 10, y
      y += 10

    if @scene_chooser_index
      lg.setColor 255, 255, 255, 120
      lg.line 10, y+3, 150, y+3
      y += 5

      lg.setColor 255, 255, 255
      lg.print "[esc] cancel", 10, y
      y += 10

      for i, scene in ipairs SCENES
        lg.setColor 255, 255, 255, if i == @scene_chooser_index then 255 else 180
        x = if i == @scene_chooser_index then 14 else 10
        lg.print scene, x, y
        y += 10

    lg.setColor 255, 255, 255, 120
    lg.line 10, y+3, 150, y+3
    y += 5

    lg.setColor 255, 255, 255
    for k, v in pairs SCENE.state
      lg.print "#{k}: #{v}", 10, y
      y += 10

    @lasth = y

{
  :DebugMenu,
}
