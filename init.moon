{graphics: lg, keyboard: lk, mouse: lm, audio: la, event: le} = love

lg.setDefaultFilter "nearest", "nearest"

Vector = require "lib.hump.vector"
HC = require "lib.HC"
import Watcher from require "watcher"
import Player from require "player"
import PSDSheet from require "psdsheet"
import PSDScene from require "psdscene"
import Interactive from require "interactive"
export ^

LOG_ERROR = (...) ->
  {:name, :source, :currentline} = debug.getinfo 2
  print "ERR", "#{name}#{source}:#{currentline}", ...
  unless DEBUG or true
    error "error logged in STDOUT"

PROJ   = Vector 1, .45
UNPROJ = Vector 1, 1/PROJ.y

WATCHER = Watcher!
WIDTH, HEIGHT = lg.getDimensions!

-- image = PSDSheet "assets/anim.psd", .3
SCENE = PSDScene "level"

--i = Interactive Vector 400, 250

--artal = require "lib.artal.artal"
--require "moon.all"
--p artal.newPSD "assets/anim_bu.psd"

player = Player 200, 200

love.keypressed = (key) ->
  switch key
    when "escape"
      le.push "quit"

love.update = (dt) ->
  WATCHER\update!

  SCENE\update dt

  --player\update dt
  --image\update dt

love.draw = ->
  SCENE\draw!
  --player\draw!
  --image\draw!

love.mousepressed = (x, y, btn) ->
  player\goto UNPROJ\permul Vector x, y
  if x > 300
    i\click!
