Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
  if SCENE.state.police == 1
		if SCENE.lieutenant == nil
			@lieutenant\say "officer, you got the pictures?"
			res = @player\choice { yes: "yes, sir. here you go", _label: "yes" },
													 { no: "no, sir. ill pick them up now", _label: "no" }
			if res == "yes"
				@commentlieutenant\say "you gave the pictures to lieutenant mcmiller"
				SCENE.state.police = 2
			if res == "no"
				@lieutenant\say "hurry up parelli"
			SCENE.lieutenant = 1
		elseif SCENE.lieutenant == 1
			@lieutenant\say "officer, you got the pictures?"
			res = @player\choice { yes: "yes, sir. here you go", _label: "yes" },
													 { no: "no, sir. ill pick them up now", _label: "no" }
			if res == "yes"
				@commentlieutenant\say "you gave the pictures to lieutenant mcmiller"
				SCENE.state.police = 2
			if res == "no"
				@lieutenant\say "what is wrong with you parelli?"
				@lieutenant\say "how can it be so hard to pick up some pictures?"

	elseif SCENE.state.police >= 1 and SCENE.state.police < 6
		@lieutenant\say "Parelli, i hope it is important"
		@player\say ".%%%%%%.%%%%%%.%%%%%% not really"
