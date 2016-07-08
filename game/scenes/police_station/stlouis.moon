Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
	if SCENE.state.police == 1
		@stlouis\say "I have to write this report, please leave me alone"
		@player\say ".%%%.%%%.%%%"
	if SCENE.state.police == 2
		@player\say "hey st.louis, still writing on yesterdays report?"
		@stlouis\say "hello parelli! yes, i am still a bit unsure of the last paragraph."
		@player\say "yes actually! i really like them"
		@player\say "agreed! Do you know who took them?"
		@stlouis\say "mh, not sure. i heard it was an investigator, but who I don't know"
		@player\say "thanks buddy"
		SCENE.state.police = 3
