import Dialogue from require "game.dialogue"
Vector = require "lib.hump.vector"

main = Dialogue =>
  @hector\say "hi!"
  @raymond\say "hi"
  @hector\say "what a crazy night."
  @raymond\say "uhm. yeah."
  @hector\say "..."
  @hector\say "what's troubling you?"

  res = @raymond\choice { life: "my life is a fucking mess", _label: "life" },
                        { work: "it's just about work", _label: "work" },
                        { nothing: "it's nothing important", _label: "nothing"}

  @hector\say switch res
    when "life" then "whose isn't? all of us fools have something to chew on."
    when "work" then "not surprised. all of us fools have something to chew on"
    when "nothing" then "it's always important. especially if you're the type that hangs around here."

  @raymond\say "what do you mean?"
  @hector\say "hey look around. everybody here is a misfit weirdo."
  @hector\say "if you have problems, this is the place where you find someone to share it with."
  @raymond\say "now you're clearly suggesting that someone is you."
  @hector\say ".%%%%%.%%%%%.%%%%%"
  @hector\say "maybe i am"
  @raymond\say ".%%%%%%%%%.%%%%%%%%%.%%%%%%%%%"
  @raymond\say "maybe"
  @raymond\say ".%%%%%%%%%.%%%%%%%%%.%%%%%%%%%"

  SCENE\transition_to "police_station"

{
  init: =>
    switch @scene
      when "first_encounter", "first_encounter.main"
        main\start!
      when "first_encounter.menu"
        hit = @hit\rectangle 0, 0, @width, @height
        hit.mousepressed = ->
          @hit\remove hit
          @tags.path\start!
}
