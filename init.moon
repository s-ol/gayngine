{graphics: lg, keyboard: lk, mouse: lm, audio: la, event: le} = love

lg.setDefaultFilter "nearest", "nearest"
lg.setLineStyle "rough"

Vector = require "lib.hump.vector"
import PSDScene from require "psdscene"
export ^

DEBUG = do
  proxy = {}
  setmetatable { enabled: not _BUILD },
    __call: (tgl) =>
      if tgl
        @[tgl] = not @[tgl]
      @enabled
    __newindex: proxy
    __index: (key) =>
      enabled = @enabled
      if enabled
        proxy[key]
      else
        false

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

SCENE = PSDScene arg[2] or "police_station"
SCENE\init!

love.keypressed = (key) ->
  switch key
    when "escape"
      le.push "quit"
    when "d"
      DEBUG "enabled"
    when "n"
      DEBUG "navmesh"
    when "r"
      SCENE\reload! if DEBUG!
    when "right"
      SCENE.scroll += Vector 4, 0 if DEBUG!
    when "left"
      SCENE.scroll -= Vector 4, 0 if DEBUG!

love.update = (dt) ->
  WATCHER\update! if WATCHER

  SCENE\update dt

love.draw = ->
  SCENE\draw!

  if DEBUG!
    love.graphics.setColor 255, 255, 255
    love.graphics.print "[DEBUG]", 10, 10
    love.graphics.print "DIALOGUE: #{DIALOGUE}", 10, 20

love.mousepressed = (x, y, btn) ->
  SCENE\mousepressed x, y, btn
