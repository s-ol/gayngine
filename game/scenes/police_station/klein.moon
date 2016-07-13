Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
	if SCENE.state.police == 1
		@klein\say "parelli, what are you waiting for? mcmiller wants those pictures."
	elseif SCENE.state.police >= 2
		choices = {
			{ tonight: "What can you tell me about operation lovebugs, sergeant?", _label: "about tonight" },
		  { pictures: "I need to find the one who took the pictures in the lovebug-investigation", _label: "about pictures" },
		  { you: "I believe i never told you that,", _label: "about you"},
			{ nothing: "I just wanted to say that im ready for tonight!", _label: "nothing"}
		}

		out = {}
		for choice in *choices
			key = next choice
			while key and "_" == key\sub 1, 1
				key = next choice, key

			if not SCENE.state.klein[key]
				table.insert out, choice
				
		@player\say "sergeant klein?"
		@klein\say "yes, officer parelli?"
		res = @player\choice unpack out
		
		if res == "tonight"
			SCENE.state.klein.tonight = true
			
			@player\say "Id like to go in there as prepared as possible"
			@klein\say "As you know we collected evidence that a club called lovebugs may be the center of a drug-cartel"
			@klein\say "Several previously convicted individuals appear to visit the establishment frequently"
			@klein\say "Tonight we will raid the club and confiscate relevant material"
			@klein\say "I am looking forward to find enough incriminating evidence to close the club and arrest its owner"
			@klein\say "An individual called hector"
			@player\say "Thanks for the update sergeant"
		elseif res == "pictures"
			SCENE.state.klein.pictures = true
			
			@player\say "apparently some of the negatives went missing"
			@player\say "do you know something about him.%%%%.%%%%.%%%%%"
			@player\say "or her?"
			@klein\say "god damnit, not again!"
			@klein\say "all I know is that it was some detective from outside the department."
			@klein\say "but you did a good job taking it in your hand."
			@klein\say "go ahead and look for him"
			@klein\say "maybe Ms. Clark can tell you more about it."
			
			@description\say "A private investigator?"
			@description\say "I guess its because we are so hoplessly understaffed that they need the help of outsiders"
			@description\say "Now i just have to find his name"
			
			SCENE.state.police = 3
			SCENE.state.receptionist = "ready"
			SCENE.state.trout.pictures = true

		elseif res == "you"
			SCENE.state.klein.you = true
			
			@player\say "but i really respect you and your work"
			@player\say "it is an honor to serve under you, sergeant."
			@klein\say "thank you officer"
			@klein\say "i am proud to work with such dedicated and loyal men and women"
		elseif res == "nothing"
			@klein\say "good to hear officer!"