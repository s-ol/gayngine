Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
	SCENE.state.johnson == nil
		@player\say "hello, sir?"
		@johnson\say "yes? whats the matter son?"
		@player\say "you are david johnson"
		@player\say "you did the investigation on this club"
		@player\say "whats the name again.%%%%%%%.%%%%%%%%%%.%%%%%%%"
		@player\say "lovebugs or something...?"
		@johnson\say "yea thats me"
		@johnson\say "took some pictures, nothing much though"
		@johnson\say "how can I help you?"
		res = @player\choice { waters: "today we arrested a man for anothother drug-related felony", _label: "test the waters" },
												 { maneuver: "well, I was at the club...you know?", _label: "strategic maneuver" },
												 { personal: "ah nothing really", _label: "personal interest"}
		if res == "waters"
			@player\say "carl .%%%%.%%%%%.%%%% mclouis"
			@player\say "blond hair, muscular type"
			@player\say "we think that he could be connected to the clubs drugscene, but couldn't find him on the pictures"
			@player\say "do you maybe remember seeing him at the club?"
			@johnson\say "mcLouis you say?"
			@johnson\say ".%%%%%.%%%%%.%%%%%"
			@johnson\say "nevermind"
			@johnson\say "to be honest, i stopped memorizing faces long time ago, you know, it's just too many of em."
			@johnson\say "i take the pictures, i write the reports and thats it"
			@player\say "i see"
			@player\say "i would like to have a look at the report"
			@player\say "maybe i can find the guy"
			@johnson\say "sure"
			@johnson\say "ask leo spiegel in the archives down the hall"
			@johnson\say "im sure he can help you"
			@player\say "thank you sir"
		elseif res == "personal"
			@player\say "just personal interest in your line of work"
			@player\say "i always wanted to become an investigator, but they said it wouldnt pay as well"
			@player\say "so i am curious"
			@player\say "do you remember all the people you takin pictures of or you writin some notes"
			@player\say "how you go about it?"
			@johnson\say "well, its true, the payment is miserable, you gotta love the job"
			@johnson\say "when I started I tried to remember everything you know?"
			@johnson\say "every little detail, face, place"
			@johnson\say "but i gave up on this, you got to realize what youre bad at"
			@johnson\say "so i started to take notes and write reports"
			@johnson\say "i take the pictures, i write the reports and thats it"
			@player\say "interesting"
			@player\say "i would like to have a look at some of the reports"
			@player\say "maybe i can find something"
			@johnson\say "sure"
			@johnson\say "ask leo spiegel in the archives down the hall"
			@johnson\say "im sure he can help you"
			@player\say "thank you sir"
		elseif res == "maneuver"
			@player\say "doin’ my own little undercover-investigation"
			@player\say "to impress the lieutenant"
			@player\say "just wanted to know if we drew same conclusions…"
			@johnson\say "interesting..."
			@johnson\say "i respect that son"
			@johnson\say "when I was younger I used to step out of the boundaries as well"
			@johnson\say "doin’ a little extra work here and there"
			@johnson\say ".&&&&&.&&&&.good times&&&&&"
			@player\say "but im sorry, cant help you"
			@johnson\say "to be honest, i stopped memorizing faces long time ago, you know, it's just too many of em."
			@johnson\say "i take the pictures, i write the reports and thats it"
			@player\say "i would like to have a look at the report"
			@player\say "maybe i can find something"
			@johnson\say "sure"
			@johnson\say "ask leo spiegel in the archives down the hall"
			@johnson\say "im sure he can help you"
			@player\say "thank you sir"
			SCENE.state.johnson = 1