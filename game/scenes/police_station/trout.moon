Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
	@trout\say "i like donuts!"
	@player\say "yea i can see ..."
	@trout\say "and burgers!"
