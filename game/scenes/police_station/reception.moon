Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
  @receptionist\say "hey, what do you need?"
  @player\say "nothing, you just suck man"
  @receptionist\say "cmon, don't be like that...."
