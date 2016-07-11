Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
	SCENE.state.hagen = "talking"
	if SCENE.state.police == 1
		@player\say "hagen, pretending you can read?"
		@hagen\say "Parelli, what is it?"
		@hagen\say "Did you already bring the pictures?"
		@hagen\say "You know that mcmiller doesn’t like to wait"
	elseif SCENE.state.police == 2
		@player\say "hagen!"
		@hagen\say "parelli! what is up?"
		res = @player\choice { tonight: "how you feel about tonight?", _label: "about tonight" },
												 { photos: "i was wondering:", _label: "about photos" },
												 { us: "how long have we been partners by now?", _label: "about us" },
												 { you: "how is your daughters chickpox?", _label: "about you" },
												 { nothing: "ahh.%%%%.%%%%.%%%% nothing", _label: "nothing" }
		if res == "tonight"
			@hagen\say "to be honest with you, i dont feel too well about it."
			@hagen\say "i mean operation cyclops didnt gave us a whole lotta reason to go on"
			@hagen\say "neither did the undercover investigation."
			@hagen\say "dunno, man, maybe we should better be leavin’ them alone…"
		elseif res == "photos"
			@player\say "do you know who took the latest pictures of the club?"
			@player\say "want to compliment the guy, great work of art there!"
			@hagen\say "yeah, great undercover-artist! Haha…"
			@hagen\say "seriously though, im not sure who it did but it wasnt someone from the department"
			@hagen\say "i heard it was some private investigator"
			SCENE.state.police = 3
			SCENE.state.receptionist = "ready"
		elseif res == "us"
			@player\say "six years?"
			@player\say "and you never said you loved me"
			@hagen\say "oh man, you know i do. want me to say it?"
			@hagen\say "maybe i can suck your dick after the shift, to prove my love haha"
			@hagen\say "honestly though, maybe i should be more open about how much i appreciate you as a partner"
			@hagen\say ".%%%%%.%%%%%.%%%%%.and then suck your dick!"
		elseif res == "you"
			@player\say "im sure seeing some red spots on you the other day"
			@hagen\say "yea, you know, cindy is better, but .%%%%%.%%%%%.%%%%%"
			@hagen\say "but i think youre right .%%%%%.%%%%%.%%%%%"
 			@hagen\say "im itching everywhere"
			@hagen\say "not because of chickpox though"
			@hagen\say "i think i did catch something from your mother last night."
		elseif res == "nothing"
			@player\say "ahhh%%%%%%%nothing"
			@hagen\say ".%%%%%.%%%%%.%%%%%"
	elseif SCENE.state.police == 3
		@player\say "hagen!"
		@hagen\say "parelli! working is not your thing i guess?"
		res = @player\choice { tonight: "how you feel about tonight?", _label: "about tonight" },
												 { investigator: "i was wondering:", _label: "about photos" },
												 { us: "how long have we been partners by now?", _label: "about us" },
												 { you: "how is your daughters chickpox?", _label: "about you" },
												 { nothing: "ahh.%%%%.%%%%.%%%% nothing", _label: "nothing" }
		if res == "tonight"
			@hagen\say "to be honest with you, i dont feel too well about it."
			@hagen\say "i mean operation cyclops didnt gave us a whole lotta reason to go on"
			@hagen\say "neither did the undercover investigation."
			@hagen\say "dunno, man, maybe we should better be leavin’ them alone…"
		if res == "investigator"
			@player\say "do you know which investigator took the pictures?"
			@hagen\say "nope, sorry man"
			@hagen\say "but if you really want to compliment him so badly"
			@hagen\say "maybe you ask kimberly at the reception"
		if res == "us"
			@player\say "six years?"
			@player\say "and you never said you loved me"
			@hagen\say "oh man, you know i do. want me to say it?"
			@hagen\say "maybe i can suck your dick after the shift, to prove my love Haha"
  		@hagen\say "i heard it was some private investigator, but no idea which one…"
			@hagen\say "honestly though, maybe i should be more open about how much i appreciate you as a partner"
			@hagen\say ".%%%%%.%%%%%.%%%%%.and then suck your dick!"
		if res == "you"
			@player\say "im sure seeing some red spots on you the other day"
			@hagen\say "yea, you know, cindy is better, but .%%%%%.%%%%%.%%%%%"
			@hagen\say "but i think youre right .%%%%%.%%%%%.%%%%%"
 			@hagen\say "i'm itching everywhere"
			@hagen\say "not because of chickpox though"
			@hagen\say "i think i did catch something from your mother last night."
		if res == "nothing"
			@player\say "ahhh%%%%%%%nothing"
			@hagen\say ".%%%%%.%%%%%.%%%%%"
		

	SCENE.state.hagen = idle