Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
  if SCENE.state.police == 1
		@lieutenant\say "officer, you got the pictures?"
		res = @player\choice { yes: "yes, sir. here you go", _label: "yes" },
												 { no: "no, sir. ill pick them up now", _label: "no" }
		if res == "yes"
			@commentlieutenant\say "you gave the pictures to lieutenant mcmiller"
			SCENE.state.police = 2
		if res == "no"
			@lieutenant\say "hurry up Parelli"

	elseif SCENE.state.police == 2
		@lieutenant\say "whoop"
