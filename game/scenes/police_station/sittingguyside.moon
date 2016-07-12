Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
	if SCENE.state.police >= 1
		if SCENE.state.sittingguyside == nil
			@sittingguyside\say "Parelli, what do you want?"
			res = @player\choice { yesterday: "I just wanted to apologize because of yesterday", _label: "about yesterday" },
													 { pictures: "Look, about those pictures i took", _label: "embarassing pictures" },
													 { mother: "About this stupid call", _label: "call to your mother"},
													 { sandwich: "I made this fresh baloney sandwich for you", _label: "fresh baloney sandwich"}
			if res == "yesterday"
				
				@sittingguyside\say "Parelli, i dont want to hear it"
				@sittingguyside\say ".%%%%%.%%%%%.%%%%%."
				@sittingguyside\say "Just leave, ok?"
				@player\say ".%%%%%.%%%%%.%%%%%."
				
				SCENE.state.sittingguyside = 1
				
			elseif res == "pictures"
				
				@sittingguyside\say "Parelli, i dont want to hear it"
				@sittingguyside\say ".%%%%%.%%%%%.%%%%%."
				@sittingguyside\say "Just leave, ok?"
				@player\say ".%%%%%.%%%%%.%%%%%."
				
				SCENE.state.sittingguyside = 1
				
			elseif res == "mother"
			
				@sittingguyside\say "Parelli, i dont want to hear it"
				@sittingguyside\say ".%%%%%.%%%%%.%%%%%."
				@sittingguyside\say "Just leave, ok?"
				@player\say ".%%%%%.%%%%%.%%%%%."
				
				SCENE.state.sittingguyside = 1
				
			elseif res == "sandwich"
				
				@sittingguyside\say "Parelli, i dont want to hear it"
				@sittingguyside\say ".%%%%%.%%%%%.%%%%%."
				@sittingguyside\say "Just leave, ok?"
				@player\say ".%%%%%.%%%%%.%%%%%."
				
				SCENE.state.sittingguyside = 1
				
		elseif SCENE.state.sittingguyside == 1
		
				@sittingguyside\say "Parelli, i dont want to hear it"
				@sittingguyside\say ".%%%%%.%%%%%.%%%%%."
				@sittingguyside\say "Just leave, ok?"
				@player\say ".%%%%%.%%%%%.%%%%%."