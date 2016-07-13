Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
	if SCENE.state.police < 7
		@player\say "its room 201"
	elseif SCENE.state.police >= 7
		@player\say "its room 201"
		res = @player\choice { enter: "Lets see if he is there", _label: "enter" },
											 { leave: "Better not", _label: "leave"}
		if res == "enter"
			SCENE\transition_to "police_station.detective office"
		elseif res == "leave"
			nothing