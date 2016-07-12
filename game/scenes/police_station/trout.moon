Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
	SCENE.state.trout or= {}
	if SCENE.state.police >=1
		choices = {
			{ photos: "i was wondering", _label: "about pictures" },
			{ operation: "davids, what do you think about operation lovebug?", _label: "about tonight" },
			{ you: "brenda i love you", _label: "about you" }
		}

		@trout\say "Raymond parelli"
		@trout\say "A pleasure for sore eyes"
		@player\say ".%%%%%%.%%%%%%.%%%%% ok"
		@player\say "You too trout"
		@trout\say "Oh, a little schmeichler, arent we?"
		@trout\say "Anyways, how may i be of service my friend?"

