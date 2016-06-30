import wrapping_, Mixin from  require "util"
Vector = require "lib.hump.vector"

dummy = Vector!

wrapping_ class CameraPath extends Mixin
  new: (scene, auto="auto", ...) =>
    super!

    speeds = {...}

    @path = {}
    for cp in *@mask.paths[1]
      point = dummy.clone(cp.cp) - Vector(WIDTH, HEIGHT)/8
      point.speed = tonumber table.remove(speeds, 1) or 120 if @path[1]
      @path[#@path+1] = point

    @start! if auto == "auto"

  start: =>
    @active = true
    @time = 0
    @pos = @path[1]

  update: (dt) =>
    return unless @active

    return if @time < 0

    @current or= 2

    while @path[@current]
      goal = @path[@current]
      delta = goal - @pos

      travel_dist = dt * goal.speed

      if delta\len! <= travel_dist
        @current += 1
        @pos = goal
      else
        delta = delta\trimmed travel_dist
        @pos += delta
        break

    if not @path[@current]
      @active = false


  apply: (last_scroll) =>
    --if @time < 0
    --  if @time < -@easetime
    --    @time = @easetime - @time
    --  else
    --    d = @time / -@easetime
    --    return last_scroll * d + @pos * -d

    @pos
