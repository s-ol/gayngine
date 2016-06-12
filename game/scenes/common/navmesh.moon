import wrapping_, Mixin from  require "util"
Vector = require "lib.hump.vector"
Polygon = require "lib.HC.polygon"
Grid = require "lib.jumper.jumper.grid"
Pathfinder = require "lib.jumper.jumper.pathfinder"

wrapping_ class NavMesh extends Mixin
  STEP = Vector 8, 20
  UNSTEP = Vector 1/STEP.x, 1/STEP.y

  new: (@scene, sx, sy, ex, ey) =>
    super!

    points = {}
    for cp in *@mask.paths[1]
      points[#points+1] = cp.cp.x
      points[#points+1] = cp.cp.y

    polygon = Polygon unpack points

    vec_step_iter = (start, stop, step) ->
      pos = start\clone!
      pos.x -= step.x -- patch first iteration
      ->
        if pos.x < stop.x
          pos.x += step.x
        elseif pos.y < stop.y - step.y
          pos.x = start.x
          pos.y += step.y
        else
          return nil
        pos

    sx or= -@ox
    sy or= -@oy
    ex or= @image\getWidth!
    ex or= @image\getHeight!
    sx, sy, ex, ey = tonumber(sx), tonumber(sy), tonumber(ex), tonumber ey

    @map = {}
    @startpos = @scene\unproject_3d Vector sx, sy
    endpos = @scene\unproject_3d Vector ex, ey
    for world in vec_step_iter @startpos, endpos, STEP
      grid = @world_to_grid world
      @map[grid.y] or= {}
      screen = @scene\project_3d world
      @map[grid.y][grid.x] = if polygon\contains screen.x, screen.y then 1 else 0

    @grid = Grid @map
    @finder = Pathfinder @grid, "THETASTAR", 1

  grid_to_world: (vec) =>
    @startpos + (vec - Vector 1, 1)\permul STEP

  grid_to_screen: (vec) =>
    @scene\project_3d @grid_to_world vec

  world_to_grid: (vec) =>
    Vector(1, 1) + (vec - @startpos)\permul UNSTEP

  draw: (draw_group, draw_layer) =>
    if DEBUG.navmesh
      for y=1,#@map
        for x=1,#@map[y]
          if @map[y][x] == 1
            love.graphics.setColor 255, 0, 0
          else
            love.graphics.setColor 0, 255, 0
          pos = @grid_to_screen Vector x, y
          love.graphics.points pos.x, pos.y
