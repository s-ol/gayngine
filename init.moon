{ graphics: lg, keyboard: lk, mouse: lm, audio: la, event: le } = love

lg.setDefaultFilter "nearest", "nearest"
lg.setLineStyle "rough"

import PSDScene from require "psdscene"
import DebugMenu from require "debugmenu"

export ^

debugmenu = DebugMenu not _BUILD
DEBUG = debugmenu.DEBUG

if DEBUG!
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

  unless DEBUG!
    error "error logged in STDOUT"

WIDTH, HEIGHT = lg.getDimensions!

PSDScene arg[2] or "first_encounter.menu"
SCENE\init!

love.keypressed = (key) ->
  return if debugmenu\keypressed key
  switch key
    when "escape"
      le.push "quit"
    else
      SCENE\keypressed key

love.update = (dt) ->
  WATCHER\update! if WATCHER

  SCENE\update dt

local lh
love.draw = ->
  SCENE\draw!
  debugmenu\draw!

love.mousepressed = (x, y, btn) ->
  SCENE\mousepressed x, y, btn
	
SCENE.state.police = 2

