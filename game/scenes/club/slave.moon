Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
	@player\say "Hello, sir?"
	@slave\say "fuck off"
	res = @player\choice	{ waters: "Well, I was at the lovebugs club", _label: "test the waters" },
												{ maneuver: "Today we arrested a man for anothother drug-related felony", _label: "strategic maneuver" },
												{ personal: "Ahh nothing special", _label: "personal interest"}

	if res == "waters"
		@player\say "carl .%%%%.%%%%%.%%%% wilder"
		@player\say "blond hair, muscular type"
		@player\say "we think that he could be connected to the clubs drugscene, but couldn't find him on the pictures"
		@player\say "do you maybe remember seeing him at the club?"
		@slave\say "wilder you say?"
		@slave\say "blond hair, muscular type?"
		@slave\say ".%%%%%.%%%%%.%%%%%"
		@slave\say "No, doesnt ring a bell, but maybe if you show me a picture of him..."
	elseif res == "personal"
		@player\say "carl .%%%%.%%%%%.%%%% wilder"
		@player\say "blond hair, muscular type"
		@player\say "we think that he could be connected to the clubs drugscene, but couldn't find him on the pictures"
		@player\say "do you maybe remember seeing him at the club?"
		@slave\say "wilder you say?"
		@slave\say "blond hair, muscular type?"
		@slave\say ".%%%%%.%%%%%.%%%%%"
		@slave\say "No, doesnt ring a bell, but maybe if you show me a picture of him..."
	elseif res == "maneuver"
		@player\say "carl .%%%%.%%%%%.%%%% wilder"
		@player\say "blond hair, muscular type"
		@player\say "we think that he could be connected to the clubs drugscene, but couldn't find him on the pictures"
		@player\say "do you maybe remember seeing him at the club?"
		@slave\say "wilder you say?"
		@slave\say "blond hair, muscular type?"
		@slave\say ".%%%%%.%%%%%.%%%%%"
		@slave\say "No, doesnt ring a bell, but maybe if you show me a picture of him..."
