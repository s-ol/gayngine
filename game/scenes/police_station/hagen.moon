Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
	SCENE.state.hagen = "talking"
	if SCENE.state.police == 1
		@player\say "hagen, pretending you can read?"
		@hagen\say "Parelli, what is it?"
		@hagen\say "Did you already bring the pictures?"
		@hagen\say "You know that mcmiller doesn’t like to wait"
	elseif SCENE.state.police == 2
		@player\say "hagen!"
		@hagen\say "parelli! what is up?"
		if SCENE.state.hagen == 0
			res = @player\choice { tonight: "how you feel about tonight?", _label: "about tonight" },
													 { photos: "i was wondering:", _label: "about photos" },
												 	 { us: "how long have we been partners by now?", _label: "about us" },
													 { you: "how is your daughters chickpox?", _label: "about you" },
													 { nothing: "ahh.%%%%.%%%%.%%%% nothing", _label: "nothing" }
			if res == "tonight"
				@hagen\say "to be honest with you, i dont feel too well about it."
				@hagen\say "i mean operation cyclops didnt gave us a whole lotta reason to go on"
				@hagen\say "neither did the undercover investigation."
				@hagen\say "dunno, man, maybe we should better be leavin’ them alone…"
			if res == "photos"
				@player\say ""
				@hagen\say ""
			if res == "us"
				@player\say ""
				@hagen\say ""
			if res == "you"
				@player\say ""
				@hagen\say ""
			if res == "nothing"

	SCENE.state.hagen = idle