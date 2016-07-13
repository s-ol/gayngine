Vector = require "lib.hump.vector"

local ret
ret = {
  init: =>
    new = switch @scene
      when "first_encounter", "first_encounter.main"
        timer = 0
        local loops

        {
          init: =>
            @state.hector = "hidden"
            @state.intro_ray = "smoking"
          update: (dt) =>
            timer += dt

            if @state.intro_ray == "smoking"
              if timer >= 14 * 0.2
                timer -= 14 * 0.2
                loops = math.random 4
                @state.intro_ray = "idle"
            else
              if timer >= loops * 3 * 0.2
                timer -= loops * 3 * 0.2
                @state.intro_ray = "smoking"
        }
      when "first_encounter.menu"
        local timer
        {
          init: =>
            hit = @hit\rectangle 0, 0, @width, @height
            hit.mousepressed = ->
              timer = 2.8
              @hit\remove hit
              @tags.path\start!
              for star in *@instances.stars
                star\start!

          update: (dt) =>
            if timer
              timer -= dt
              if timer < 0
                @transition_to "first_encounter.intro", 1
                timer = nil
        }
      when "first_encounter.intro"
        timer = 2
        {
          update: (dt) =>
            if timer
              timer -= dt
              if timer < 0
                @transition_to "first_encounter.main", 1
                timer = nil
        }
      else
        {}

    new.init @ if new.init
    for k,v in pairs new
      ret[k] = v unless k == "init"
}

ret
