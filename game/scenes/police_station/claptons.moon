Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
	if SCENE.state.clapton == nil
		SCENE.state.pclapton = "talking"
		@claptonright\say "Can you not see that we are having a conversation parelli?"
		@claptonleft\say "Yea, we are conversating dickhead"
		SCENE.state.pclapton = nil
		@player\say ".%%%.%%%.%%%"
		SCENE.state.clapton = 1
	elseif SCENE.state.clapton == 1
		@claptonright\say ".%%%%%%.%%%%%%.%%%%%%"
		@claptonleft\say ".%%%%%%.%%%%%%.%%%%%%"
		@player\say ".%%%%%%.%%%%%%.%%%%%%"