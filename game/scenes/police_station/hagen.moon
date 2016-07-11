Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
	SCENE.state.hagen or= {}
	SCENE.state.hagen_animation = "talking"
	if SCENE.state.police == 1
		@player\say "Hagen, stop pretending you could read!"
		@hagen\say "Parelli, what is it?"
		@hagen\say "Did you already bring the pictures?"
		@hagen\say "You know that mcmiller doesnt like to wait"
		
	elseif SCENE.state.police == 2
		choices = {
			{ tonight: "how you feel about tonight?", _label: "about tonight" },
			{ photos: "i was wondering:", _label: "about photos" },
			{ us: "how long have we been partners by now?", _label: "about us" },
			{ you: "how is your daughters chickpox?", _label: "about you" },
			{ nothing: "ahh.%%%%.%%%%.%%%% nothing", _label: "nothing" }
		}

		out = {}
		for choice in *choices
			key = next choice
			while key and "_" == key\sub 1, 1
				key = next choice, key

			if not SCENE.state.hagen[key]
				table.insert out, choice
			
		@player\say "Hagen!"
		@hagen\say "Parelli! what is up?"
		res = @player\choice unpack out

		if res == "tonight"
			SCENE.state.hagen.tonight = true
			@hagen\say "to be honest with you, i dont feel too well about it."
			@hagen\say "i mean operation cyclops didnt gave us a whole lotta reason to go on"
			@hagen\say "neither did the undercover investigation."
			@hagen\say "dunno, man, maybe we should better be leavin them alone"
			@player\say "i guess.%%%%%.%%%%%.%%%%%."
		elseif res == "photos"
			SCENE.state.hagen.photos = true
			SCENE.state.police = 3
			@player\say "do you know who took the latest pictures of the club?"
			@player\say "want to compliment the guy, great work of art there!"
			@hagen\say "yeah, great undercover-artist! Haha"
			@hagen\say "seriously though, im not sure who it did but it wasnt someone from the department"
			@hagen\say "i heard it was some private investigator"	
		elseif res == "us"
			SCENE.state.hagen.us = true
			@player\say "six years?"
			@player\say "and you never said you loved me"
			@hagen\say "oh man, you know i do. want me to say it?"
			@hagen\say "maybe i can suck your dick after the shift, to prove my love haha"
			@hagen\say "honestly though, maybe i should be more open about how much i appreciate you as a partner"
			@hagen\say ".%%%%%.%%%%%.%%%%%.and then suck your dick!"
		elseif res == "you"
			SCENE.state.hagen.you = true
			@player\say "im sure seeing some red spots on you the other day"
			@hagen\say "yea, you know, cindy is better, but .%%%%%.%%%%%.%%%%%"
			@hagen\say "but i think youre right .%%%%%.%%%%%.%%%%%"
			@hagen\say "im itching everywhere"
			@hagen\say "not because of chickpox though"
			@hagen\say "i think i did catch something from your mother last night."
		elseif res == "nothing"
			@player\say "ahhh%%%%%%%nothing"
			@hagen\say ".%%%%%.%%%%%.%%%%%"
			
	elseif SCENE.state.police >= 3
		choices = {
			{ tonight: "how you feel about tonight?", _label: "about tonight" },
			{ investigator: "i was wondering:", _label: "about photos" },
			{ us: "how long have we been partners by now?", _label: "about us" },
			{ you: "how is your daughters chickpox?", _label: "about you" },
			{ nothing: "ahh.%%%%.%%%%.%%%% nothing", _label: "nothing" }
		}

		out = {}
		for choice in *choices
			key = next choice
			while key and "_" == key\sub 1, 1
				key = next choice, key

			if not SCENE.state.hagen[key]
				table.insert out, choice
				
		@player\say "Hagen!"
		@hagen\say "Parelli! what is up?"
		res = @player\choice unpack out

		if res == "tonight"
			SCENE.state.hagen.tonight = true
			@hagen\say "to be honest with you, i dont feel too well about it."
			@hagen\say "i mean operation cyclops didnt gave us a whole lotta reason to go on"
			@hagen\say "neither did the undercover investigation."
			@hagen\say "dunno, man, maybe we should better be leavin them alone"
			@player\say "i guess.%%%%%.%%%%%.%%%%%."
		elseif res == "investigator"
			SCENE.state.hagen.investigator = true
			@player\say "do you know which investigator took the pictures?"
			@hagen\say "nope, sorry man"
			@hagen\say "but if you really want to compliment him so badly"
			@hagen\say "maybe you ask kimberly at the reception"
		elseif res == "us"
			SCENE.state.hagen.us = true
			@player\say "six years?"
			@player\say "and you never said you loved me"
			@hagen\say "oh man, you know i do. want me to say it?"
			@hagen\say "maybe i can suck your dick after the shift, to prove my love haha"
			@hagen\say "honestly though, maybe i should be more open about how much i appreciate you as a partner"
			@hagen\say ".%%%%%.%%%%%.%%%%%.and then suck your dick!"
		elseif res == "you"
			SCENE.state.hagen.you = true
			@player\say "im sure seeing some red spots on you the other day"
			@hagen\say "yea, you know, cindy is better, but .%%%%%.%%%%%.%%%%%"
			@hagen\say "but i think youre right .%%%%%.%%%%%.%%%%%"
			@hagen\say "im itching everywhere"
			@hagen\say "not because of chickpox though"
			@hagen\say "i think i did catch something from your mother last night."
		elseif res == "nothing"
			@player\say "ahhh%%%%%%%nothing"
			@hagen\say ".%%%%%.%%%%%.%%%%%"
			
	SCENE.state.hagen_animation = nil
