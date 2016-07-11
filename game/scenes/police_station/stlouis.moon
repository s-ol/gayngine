Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
	if SCENE.state.police == 1
		@stlouis\say "I have to write this report, please give me just a minute"
		@player\say ".%%%.%%%.%%%"
	elseif SCENE.state.police == 2
		@player\say "hey st.louis"
		@player\say "still writing on yesterdays report?"
		@stlouis\say "hello parelli!"
		@stlouis\say "yes, i am still a bit unsure of the last paragraph."
		@player\say "did you already had a chance to look at the pictures?"
		@stlouis\say "yes actually! i really like them"
		@player\say "agreed! do you know who took them?"
		@stlouis\say "mh, not sure. i heard it was a private investigator, but who I don't know"
		@player\say "thanks buddy"
		SCENE.state.police = 3
		SCENE.state.receptionist = "ready"
	elseif SCENE.state.police == 3
		@stlouis\say "this one paragraph"
		@stlouis\say "i just cant get it right"
		@player\say ".&&&&.&&&&.&&&&"
