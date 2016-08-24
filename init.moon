{ graphics: lg, keyboard: lk, mouse: lm, audio: la, event: le } = love

lg.setDefaultFilter "nearest", "nearest"
lg.setLineStyle "rough"

import Sound from require "sound"
import PSDScene from require "psdscene"
import DebugMenu from require "debugmenu"

export ^

DEBUG = DebugMenu not _BUILD
-- DEBUG = DEBUG.DEBUG

if not _BUILD
  export MOON, WATCHER
  import Watcher from require "watcher"
  MOON = require "moon"

  WATCHER = Watcher!

lg.setNewFont("assets/SomepxNew.ttf", 16)\setLineHeight 0.56
lk.setKeyRepeat true

WIDTH, HEIGHT = lg.getDimensions!

SOUND = Sound!
PSDScene arg[2] or "first_encounter.menu"
SCENE\init!

love.keypressed = (key) ->
  return if DEBUG\keypressed key
  switch key
    when "escape"
      le.push "quit"
    else
      SCENE\keypressed key if SCENE.keypressed
love.keyreleased = (...) -> DEBUG\keyreleased ...
love.textinput = (...) -> DEBUG\textinput ...

love.update = (dt) ->
  WATCHER\update! if WATCHER

  SCENE\update dt
  DEBUG\update dt

love.draw = ->
  SCENE\draw!

  lg.setColor 255, 255, 255
  DEBUG\draw!

love.errhand = (msg) ->
  lg.setBackgroundColor 0, 0, 0
  lg.setNewFont!
  lg.origin!

  msg = tostring msg
  trace = debug.traceback!
  print msg
  print trace

  while true
    love.event.pump!

    for e, a, b, c in love.event.poll!
      switch e
        when "quit" then return
        when "mousepressed" then DEBUG\mousepressed a, b, c
        when "mousemoved" then DEBUG\mousemoved a, b, c
        when "mousereleased" then DEBUG\mousereleased a, b, c
        when "wheelmoved" then DEBUG\wheelmoved a, b, c
        when "textinput" then DEBUG\textinput a, b, c
        when "keyreleased" then DEBUG\keyreleased a, b, c
        when "keypressed" then return unless b != "escape" or DEBUG\keypressed a, b, c

    lg.clear lg.getBackgroundColor!

    lg.setColor 255, 255, 255
    lg.print "ERROR", 460, 30
    lg.print msg .. "\n\n" .. trace, 460, 50
    DEBUG\draw!

    lg.present!

    DEBUG\update!

    love.timer.sleep 0.1

love.quit = -> imgui.ShutDown!

love.mousepressed = (x, y, btn) ->
  unless DEBUG\mousepressed x, y, btn
    SCENE\mousepressed x, y, btn
love.mousemoved = (...) -> DEBUG\mousemoved ...
love.mousereleased = (...) -> DEBUG\mousereleased ...
love.wheelmoved = (...) -> DEBUG\wheelmoved ...
