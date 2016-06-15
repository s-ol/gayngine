Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
  SCENE.state.photoguy = true
  @photoguy\say "parelli, to what do i owe the honour of your visit?"
  @player\say "Hi .%%%%%.%%%%%.%%%%%."
  @photoguy\say "schnitzler, joseph, but nevermind pal" 
  @photoguy\say "i only work here for two years now."
  @player\say "im sorry joseph, im really bad with names."
  @player\say "the lieutenant sent me to pick up the latest batch"
  @photoguy\say "did he? what a coincidence, isnt it?"

  res = @player\choice { confused: ".%%%%%.%%%%%.%%%%% not quite sure what you mean", _label: "confused" },
                        { nervous: "why would you say that?", _label: "nervous" },
                        { surprised: "whait.%%%%%.%%%%%.%%%%%. why?", _label: "surprised"}