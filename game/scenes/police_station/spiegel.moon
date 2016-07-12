Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
	SCENE.state.spiegel or= {}
	if SCENE.state.police < 4
		choices = {
			{ you: "You are leo spiegel, right?", _label: "about you" },
			{ work: "What is it exactly that you are doing here?", _label: "about your work" },
			{ nothing: "Oh, i think i took the wrong turn somewhere", _label: "nothing"}
		}
		
		out = {}
		for choice in *choices
			key = next choice
			while key and "_" == key\sub 1, 1
				key = next choice, key

			if not SCENE.state.spiegel[key]
				table.insert out, choice
				
		@spiegel\say "How may i help you son?"
		res = @player\choice unpack out

		if res == "you"
			SCENE.state.spiegel.you = true
			
			@player\say "I heard a lot about you"
			@player\say "You are the longest serving member of this department?"
			@spiegel\say "Oh yes or you could say the oldest"
			@spiegel\say "I started to work here in 1933 when i was a young boy"
			@spiegel\say "I couldnt join our troops because of my eyesight so i stayed and read books"
			@spiegel\say "But then in 1954 when i met henriette i would"
			@spiegel\say ".%%%%%%%%.%%%%%%%%."
			@spiegel\say "But thats a different story i suppose"
			@splayer\say ".%%%%%%%%.%%%%%%%%."
			
		if res == "work"
			SCENE.state.spiegel.work = true
			
			@spiegel\say "Oh, i know everything about this archieves"
			@spiegel\say "I sort and find the things that need to be stored"
			@spiegel\say "Reports, papers, books...."
			@spiegel\say "But unfortunatly i am the only one who knows where everything is"
			@spiegel\say ".%%%%%%%%.%%%%%%%%.."
			@spiegel\say "I heard they will get one of those computers though"
			@splayer\say ".%%%%%%%%.%%%%%%%%."
			
		if res == "nothing"
			@spiegel\say "Oh, that happens from time to time"
	
	elseif SCENE.state.police = 4
		choices = {
			{ you: "You are leo spiegel, right?", _label: "about you" },
			{ work: "What is it exactly that you are doing here?", _label: "about your work" },
			{ investigator: "I have heard you could help me with something:", _label: "about the investigator" },
			{ nothing: "Oh, i think i took the wrong turn somewhere", _label: "nothing"}
		}
		
		out = {}
		for choice in *choices
			key = next choice
			while key and "_" == key\sub 1, 1
				key = next choice, key

			if not SCENE.state.spiegel[key]
				table.insert out, choice
				
		@spiegel\say "How may i help you son?"
		res = @player\choice unpack out

		if res == "you"
			SCENE.state.spiegel.you = true
			
			@player\say "I heard a lot about you"
			@player\say "You are the longest serving member of this department?"
			@spiegel\say "Oh yes or you could say the oldest"
			@spiegel\say "I started to work here in 1933 when i was a young boy"
			@spiegel\say "I couldnt join our troops because of my eyesight so i stayed and read books"
			@spiegel\say "But then in 1954 when i met henriette i would"
			@spiegel\say ".%%%%%%%%.%%%%%%%%."
			@spiegel\say "But thats a different story i suppose"
			@splayer\say ".%%%%%%%%.%%%%%%%%."

		elseif res == "work"
			SCENE.state.spiegel.work = true
			
			@spiegel\say "Oh, i know everything about this archieves"
			@spiegel\say "I sort and find the things that need to be stored"
			@spiegel\say "Reports, papers, books...."
			@spiegel\say "But unfortunatly i am the only one who knows where everything is"
			@spiegel\say ".%%%%%%%%.%%%%%%%%.."
			@spiegel\say "I heard they will get one of those computers though"
			@splayer\say ".%%%%%%%%.%%%%%%%%."
			
		elseif res == "investigator"
			@player\say "I need to find out which investigator took the picture of our latest investigation"
			@player\say "Can you help me with that?"
			@spiegel\say "Oh, yes yes"
			@spiegel\say "I think..."
			@spiegel\say "There is a file which conatins all the name of the investigators"
			@spiegel\say "Coincidentally i have it here under my desk"
			@spiegel\say "You want to take a look"
			res = @player\choice { yes: "Yes, please", _label: "yes" },
													 { no: "No, thanks", _label: "no"}
			if res == "yes"
				SCENE.tags.file\start!
			else
				@spiegel\say "Oh, nevermind then."
			
		elseif res == "nothing"
			@spiegel\say "Oh, that happens from time to time"
	
