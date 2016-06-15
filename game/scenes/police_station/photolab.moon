Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
  SCENE.state.photoguy = true
  @photoguy\say "parelli, to what do i owe the honour of your visit?"
  @player\say "hi .%%%%%.%%%%%.%%%%%."
  @photoguy\say "schnitzler, joseph, but nevermind pal" 
  @photoguy\say "i only work here for two years now."
  @player\say "im sorry joseph, im really bad with names."
  @player\say "the lieutenant sent me to pick up the latest batch"
  @photoguy\say "did he? what a coincidence, isnt it?"

  res = @player\choice { confused: ".%%%%%.%%%%%.%%%%% not quite sure what you mean", _label: "confused" },
                        { nervous: "why would you say that?", _label: "nervous" },
                        { surprised: "whait.%%%%%.%%%%%.%%%%%. why?", _label: "surprised"}

  for line in *{
    "im just thinking its quite funny that you got sent down here",
    "considering that you are on one of the photos outside the club talking to one of the fags"
    "As far as im informed you are no undercover detective, are you?" 
  }
    @photoguy\say line

  res = @player\choice { intimidate: "dont overstep your boundaries", _label: "intimidate" },
                        { argue: "look, i was there, so what?", _label: "argue" },
                        { beg: "please i beg you dont tell the others", _label: "beg"},
                        { bargain: "come on man, what do you need?", _label: "bargain"}
  if res == "intimidate"
    @player\say "just give me the goddamn picture!"
  elseif res == "argue"
    @player\say "i can do what I want in my free time"
    @player\say "but if you want to ruin my life and destroy my family"
    @player\say "please go ahead and show it to everyone"
  elseif res == "beg"
    @player\say ".&&&&.&&&&.&&&& i got a family"
    @player\say ".&&&&.&&&&.&&&& it would ruin me"
  elseif res == "bargain"
    @player\say ".&&&&.&&&&.&&&& money?"
    @player\say ".&&&&.&&&&.&&&& ill do whatever"
    @player\say ".&&&&.&&&&.&&&& just give me the picture."