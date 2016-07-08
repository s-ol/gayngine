Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
	if SCENE.state.police == 1
		@klein\say "parelli, what are you waiting for? mcmiller wants those pictures."
	if SCENE.state.police == 2
		@player\say "sergeant klein?"
		@klein\say "yes, officer parelli?"
		res = @player\choice { tonight: "what can you tell me about operation lovebugs, sergeant?", _label: "about tonight" },
												 { pictures: "i need to find the one who took the pictures in the lovebug-investigation", _label: "about pictures" },
												 { you: "i believe i never told you that,", _label: "about you"},
												 { nothing: "i just wanted to say that im ready for tonight!", _label: "nothing"}
		if res == "tonight"
			@player\say "id like to go in there as prepared as possible"
		if res == "pictures"
			@player\say "apparently some of the negatives went missing"
			@player\say "do you know something about him.%%%%.%%%%.%%%%%"
			@player\say "or her?"
			@klein\say "god damnit, not again!"
			@klein\say "all I know is that it was some detective from outside the department."
			@klein\say "but you did a good job taking it in your hand."
			@klein\say "go ahead and look for him"
			@klein\say "maybe Ms. Clark can tell you more about it."
			SCENE.state.police = 3
		if res == "you"
			@player\say "but i really respect you and your work"
			@player\say "it is an honor to serve under you, sergeant."
		if res == "nothing"
			@klein\say "good to hear officer!"