import wrapping_, Mixin from  require "util"
import MultiSheet from require "psdsheet"
import ORIGIN from require "game.player"
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

wrapping_ class PlayerSpawn extends Mixin
  new: (scene) =>
    super!

    point = @mask.paths[1][1]
    @pos = SCENE\unproject_3d Vector point.cp.x, point.cp.y
    @sheet = MultiSheet "game/characters/hector.psd", .15

    @path = for point in *@mask.paths[1]
      SCENE\unproject_3d Vector point.cp.x, point.cp.y
    @index = 2

  update: (dt) =>
    total = Vector!

    travel_dist = dt * 50

    while @path[@index]
      goal = @path[@index]
      delta = goal - @pos

      if delta\len! <= travel_dist
        travel_dist -= delta\len!
        @index += 1
        @pos = goal
        total += delta

        if not @path[@index]
          SCENE.state.hector = nil
          main\start!
      else
        delta = delta\trimmed travel_dist
        @pos += delta
        total += delta
        break

    @sheet\update total, dt
    if not @sheet.anim\match "idle"
      if not (@last_sound and @last_sound\isPlaying!)
        @last_sound = SOUND\play "steps/step#{math.random 16}", 0.4, false, @pos

  draw: =>
    return unless @path[@index]
    { :x, :y } = SCENE\project_3d(@pos) - ORIGIN
    @sheet\draw math.floor(x), math.floor y
