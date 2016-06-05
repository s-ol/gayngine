import Dialogue from require "game.dialogue"

main = Dialogue =>
  @hector\say "hi!"
  @raymond\say "hi"
  @hector\say "what a crazy night."
  @raymond\say "uhm. yeah."
  @hector\say "..."
  @hector\say "what's troubling you?"

  res = @raymond\choice { life: "my life is a fucking mess", _label: "my life is a mess" },
                        { work: "it's just about work", _label: "problems at work" },
                        { nothing: "it's nothing important" }

  @hector\say switch res
    when "life" then "whose isn't? all of us fools have something to chew on."
    when "work" then "not surprised. all of us fools have something to chew on"
    when "nothing" then "it's always important. especially if you're the type that hangs around here."

  @raymond\say "what do you mean?"
  @hector\say "hey look around. everybody here is a misfit weirdo."
  @hector\say "if you have problems, this is the place where you find someone to share it with."
  @raymond\say "now you're clearly suggesting that someone is you."
  @hector\say "i'm not. but i believe i am qualified."

main\start!
