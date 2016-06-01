import wrapping_, Mixin from  require "util"
Vector = require "lib.hump.vector"
Polygon = require "lib.HC.polygon"
Grid = require "lib.jumper.jumper.grid"
Pathfinder = require "lib.jumper.jumper.pathfinder"

wrapping_ class NavMesh extends Mixin
  X_STEP = 40
  Y_STEP = 8

  new: =>
    super!

    points = {}
    for cp in *@mask.paths[1]
      points[#points+1] = cp.cp.x
      points[#points+1] = cp.cp.y

    polygon = Polygon unpack points

    @map = {}
    sy = 0
    for y=-@oy, @image\getHeight! - @oy, Y_STEP
      sy += 1
      sx = 0
      @map[sy] = {}
      for x=-@ox, @image\getWidth! - @ox, X_STEP
        sx += 1
        @map[sy][sx] = if polygon\contains x, y then 1 else 0

    @grid = Grid @map
    @finder = Pathfinder @grid, "THETASTAR", 1

  draw: (draw_group, draw_layer) =>
    ry = -@oy
    for y=1,#@map
      rx = -@ox
      for x=1,#@map[y]
        if @map[y][x] == 1
          love.graphics.setColor 255, 0, 0
        else
          love.graphics.setColor 0, 255, 0
        love.graphics.circle "fill", rx, ry, 2
        rx += X_STEP
      ry += Y_STEP

