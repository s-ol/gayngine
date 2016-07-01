import wrapping_, Mixin from  require "util"
Vector = require "lib.hump.vector"
Polygon = require "lib.HC.polygon"
Grid = require "lib.jumper.jumper.grid"
Pathfinder = require "lib.jumper.jumper.pathfinder"

runpack = (vec) -> math.floor(vec.x + .5), math.floor vec.y + .5
rounded = (vec) -> Vector math.floor(vec.x + .5), math.floor vec.y + .5

vec_step_iter = (start, stop, step=Vector(1, 1)) ->
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
    pos\clone!

wrapping_ class NavMesh extends Mixin
  STEP = Vector 8, 20
  UNSTEP = Vector 1/STEP.x, 1/STEP.y
  CHAR_SIZE = Vector 18, 4

  new: (@scene, sx, sy, ex, ey) =>
    super!

    @points = {}
    for cp in *@mask.paths[1]
      @points[#@points+1] = cp.cp.x
      @points[#@points+1] = cp.cp.y

    polygon = Polygon unpack @points

    sx or= -@ox
    sy or= -@oy
    ex or= @image\getWidth! - @ox
    ey or= @image\getHeight! - @oy
    sx, sy, ex, ey = tonumber(sx), tonumber(sy), tonumber(ex), tonumber ey

    checks = [check for check in vec_step_iter CHAR_SIZE/-2, CHAR_SIZE/2, Vector 3, 2]

    @map = {}
    @startpos = @scene\unproject_3d Vector sx, sy
    endpos = @scene\unproject_3d Vector ex, ey
    for world in vec_step_iter @startpos, endpos, STEP
      grid = @world_to_grid world
      @map[grid.y] or= {}
      screen = @scene\project_3d world

      res = 1
      for vec in *checks
        if not polygon\contains (screen + vec)\unpack!
          res = 0
          break
      @map[grid.y][grid.x] = res

    @grid = Grid @map
    @finder = Pathfinder @grid, "THETASTAR", 1

  grid_to_world: (vec) =>
    @startpos + (vec - Vector 1, 1)\permul STEP

  grid_to_screen: (vec) =>
    @scene\project_3d @grid_to_world vec

  world_to_grid: (vec) =>
    Vector(1, 1) + (vec - @startpos)\permul UNSTEP

  closest_walkable: (vec) =>
    vec = rounded @world_to_grid vec
    if @grid\isWalkableAt vec.x, vec.y, 1
      vec\unpack!
    else
      dist = math.huge
      local best
      for new in vec_step_iter vec - Vector(4, 4), vec + Vector(4, 4)
        if @grid\isWalkableAt(new.x, new.y, 1) and dist > vec\dist new
          dist = vec\dist new
          best = new

      best\unpack! if best

  draw: (draw_group, draw_layer) =>
    if DEBUG.navmesh
      love.graphics.setColor 0, 255, 0, 120
      love.graphics.polygon "line", unpack @points
      for y=1,#@map
        for x=1,#@map[y]
          if @map[y][x] == 1
            love.graphics.setColor 0, 255, 0
          else
            love.graphics.setColor 255, 0, 0, 120
          pos = @grid_to_screen Vector x, y
          love.graphics.points pos.x, pos.y
