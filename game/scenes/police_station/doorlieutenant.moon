Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
	if SCENE.state.police == nil
		@player\say "its the lieutenants office"
		@player\say "noone seems to be inside"
	elseif SCENE.state.police >= 1
		@player\say "its the lieutenants office"
		res = @player\choice { enter: "enter" },
													{ leave: "leave" }
		if res == "enter"
			SOUND\play "door"
			SCENE\transition_to "police_station.chief_office"
		elseif res == "leave"
			@player\say "better leave him alone..."
