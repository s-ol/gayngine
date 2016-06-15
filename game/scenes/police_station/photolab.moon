Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
  SCENE.state.photoguy = true
  @photoguy\say "parelli, to what do I owe the honour of your visit?"
  @player\say "Hi .%%%%%.%%%%%.%%%%%."
  @photoguy\say "schnitzler, joseph, but nevermind pal" 
  @photoguy\say "i only work here for two years now."
  @player\say "Im sorry joseph, I’m really bad with names."
  @player\say "The lieutenant sent me to pick up the latest batch"
  @photoguy\say "did he? what a coincidence, isnt it?"