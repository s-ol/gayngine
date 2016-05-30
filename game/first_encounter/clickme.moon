import wrapping_, Mixin from  require "util"

wrapping_ class SubAnim extends Mixin
  new: (@scene) =>
    super!

    for lyr in *@
      switch lyr.name
        when "clickarea"
          @mask = lyr.mask
        when "idle"
          @idle = lyr
        when "hover"
          @hover = lyr

    points = {}
    for point in *@mask.paths[1]
      points[#points+1] =  point.cp.x
      points[#points+1] =  point.cp.y

    @hitarea = scene.hit\polygon unpack points
    @hitarea.mousepressed = @\mousepressed

  mousepressed: =>
    DIALOGUE\start!

  draw: (draw_group, draw_layer) =>
    if @scene.hoveritems[@hitarea]
      draw_layer @hover
    else
      draw_layer @idle
