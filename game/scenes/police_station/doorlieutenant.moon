Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
	@player\say "its the lieutenants office"
	res = @player\choice { enter: "enter", _label: "enter" },
											 { leave: "leave", _label: "leave"}
	if res == "enter"
		SCENE\transition_to "chief_office"
	elseif res == "leave"
		@player\say "better not disturb him"