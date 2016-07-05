import MultiSheet from require "psdsheet"
import Reloadable from require "util"
Vector = require "lib.hump.vector"

{ keyboard: lk } = love

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

    local last, delta
    if @path
      @path.index or= 2

      nav = @scene.tags.nav
      travel_dist = dt * SPEED

      while @path._nodes[@path.index]
        goal = @path._nodes[@path.index]
        goal = nav\grid_to_world Vector goal._x, goal._y
        delta = goal - @pos

        if delta\len! <= travel_dist
          travel_dist -= delta\len!
          lp = @path._nodes[@path.index]
          @last_pos = Vector lp._x, lp._y
          @path.index += 1
          @pos = goal
          total += delta
        else
          delta = delta\trimmed travel_dist
          @pos += delta
          total += delta
          last = true
          break

    @sheet\update total, dt

    local close
    if @path and not @path._nodes[@path.index]
      @path.cb! if @path.cb
      @path = nil

    if not DIALOGUE and (not @path or (last and delta\len2! < 2))
      walk =
        w: Vector 0, -1
        s: Vector 0,  1
        a: Vector -1, 0
        d: Vector  1, 0
        up: Vector 0, -1
        down: Vector 0,  1
        left: Vector -1, 0
        right: Vector  1, 0

      dir = Vector!
      for key, vec in pairs walk
        if lk.isDown key
          dir += vec

      if dir\len2! > 0
        @moveTo @pos + dir * 20

  draw: (obey=true) =>
    return if @hidden and obey

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

    local sx, sy
    if @last_cp
      sx, sy = @last_cp\unpack!
    else
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
