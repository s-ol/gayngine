import MultiSheet from require "psdsheet"
import Reloadable from require "util"
Vector = require "lib.hump.vector"

class Player extends Reloadable
  ORIGIN = Vector 16, 65
  SPEED = 80
  new: (@scene, @skin, @pos=Vector!) =>
    super!

    @sheet = MultiSheet "game/characters/#{@skin}.psd", .15

  reload: (...) =>
    new = super ...

    setmetatable @, new.Player.__base

  update: (dt) =>
    total = Vector!
    if @path
      @path.index or= 1

      nav = @scene.tags.nav
      travel_dist = dt * SPEED

      while @path._nodes[@path.index]
        goal = @path._nodes[@path.index]
        goal = nav\grid_to_world Vector goal._x, goal._y
        delta = goal - @pos

        if delta\len! <= travel_dist
          travel_dist -= delta\len!
          @path.index += 1
          @pos = goal
          total += delta
        else
          delta = delta\trimmed travel_dist
          @pos += delta
          total += delta
          break

    @sheet\update total, dt

    if @path and not @path._nodes[@path.index]
      @path.cb! if @path.cb
      @path = nil

  draw: =>
    { :x, :y } = @scene\project_3d(@pos) - ORIGIN
    @sheet\draw math.floor(x), math.floor(y)

    if @path and DEBUG.navmesh
      love.graphics.setColor 0, 0, 255, 80
      nav = @scene.tags.nav

      goal = @path._nodes[#@path._nodes]
      goal = nav\grid_to_screen Vector goal._x, goal._y
      love.graphics.circle "fill", goal.x, goal.y, 1

      local last
      for node in *@path._nodes
        pos = nav\grid_to_screen Vector node._x, node._y

        if last
          love.graphics.line last.x, last.y, pos.x, pos.y

        last = pos

  moveTo: (goal, cb) =>
    nav = @scene.tags.nav
    sx, sy = nav\closest_walkable @pos
    gx, gy = nav\closest_walkable goal

    if gx and gy
      @path = nav.finder\getPath sx, sy, gx, gy
      @path.cb = cb if @path
    else
      print "not walkable!"
      cb! if cb

{
  :Player,
}
