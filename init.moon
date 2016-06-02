{graphics: lg, keyboard: lk, mouse: lm, audio: la, event: le} = love

lg.setDefaultFilter "nearest", "nearest"

Vector = require "lib.hump.vector"
import PSDScene from require "psdscene"
export ^

DEBUG = not _BUILD

if DEBUG
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

  unless DEBUG
    error "error logged in STDOUT"

WIDTH, HEIGHT = lg.getDimensions!

SCENE = PSDScene arg[2] or "police_station"
SCENE\init!

love.keypressed = (key) ->
  switch key
    when "escape"
      le.push "quit"
    when "d"
      DEBUG = not DEBUG
    when "r"
      if DEBUG
        SCENE\reload!
    when "right"
      SCENE.scroll -= Vector 4, 0
    when "left"
      SCENE.scroll += Vector 4, 0

love.update = (dt) ->
  WATCHER\update! if WATCHER

  SCENE\update dt

love.draw = ->
  SCENE\draw!

love.mousepressed = (x, y, btn) ->
  SCENE\mousepressed x, y, btn
