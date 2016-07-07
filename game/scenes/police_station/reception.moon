Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
  if SCENE.state.police == nil
		@receptionist\say "'ill be back in 10'"
		@receptionist\say "-kimberly"
  elseif SCENE.state.police == 1
		@receptionist\say "one moment"
		@player\say ".%%%.%%%.%%%"
  elseif SCENE.state.police == 2
		@receptionist\say "one moment"
		@player\say ".%%%.%%%.%%%"
