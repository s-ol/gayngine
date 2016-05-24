{graphics: lg, keyboard: lk, mouse: lm, audio: la, event: le} = love

lg.setDefaultFilter "nearest", "nearest"

Vector = require "lib.hump.vector"
import Watcher from require "watcher"
import PSDScene from require "psdscene"
import Interactive from require "interactive"
export ^

LOG = (msg, indent=0) ->
  indent = " "\rep indent

  print "LOG", indent .. msg

LOG_ERROR = (msg, indent=0) ->
  indent = " "\rep indent
  {:name, :source, :currentline} = debug.getinfo 2

  print "ERR", indent .. "#{name}#{source}:#{currentline}", msg

  unless DEBUG or true
    error "error logged in STDOUT"

PROJ   = Vector 1, .45
UNPROJ = Vector 1, 1/PROJ.y

WATCHER = Watcher!
WIDTH, HEIGHT = lg.getDimensions!

SCENE = PSDScene "first_encounter"

love.keypressed = (key) ->
  switch key
    when "escape"
      le.push "quit"

love.update = (dt) ->
  WATCHER\update!

  SCENE\update dt

love.draw = ->
  SCENE\draw!

love.mousepressed = (x, y, btn) ->
