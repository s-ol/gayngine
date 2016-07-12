Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
	if SCENE.state.police >= 1
		@stern\say "I have to write this report, please leave me alone"
		@player\say ".%%%.%%%.%%%"
