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

LOG = (msg, indent=0) ->
  indent = " "\rep indent

  print "LOG", indent .. msg

LOG_ERROR = (msg, indent=0) ->
  indent = " "\rep indent
  {:name, :source, :currentline} = debug.getinfo 2

  print "ERR", indent .. "#{name}#{source}:#{currentline}", msg

  if _BUILD
    error "error logged in STDOUT"

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
      SCENE\keypressed key
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

love.quit = -> imgui.ShutDown!

love.mousepressed = (x, y, btn) ->
  unless DEBUG\mousepressed x, y, btn
    SCENE\mousepressed x, y, btn
love.mousemoved = (...) -> DEBUG\mousemoved ...
love.mousereleased = (...) -> DEBUG\mousereleased ...
love.wheelmoved = (...) -> DEBUG\wheelmoved ...
love.textinput = (...) -> DEBUG\textinput ...
