Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
	@claptonright\say "look at this shithead"
	@claptonleft\say "yea, he sucks"
	@player\say ".%%%.%%%.%%%"
