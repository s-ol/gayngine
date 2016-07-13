Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
	SCENE.state.trout or= {}
	if SCENE.state.police >= 2 and SCENE.state.trout_oppinion == nil
		choices = {
			{ pictures: "i was wondering", _label: "about pictures" },
			{ tonight: "What do you think about our operation tonight", _label: "about tonight" },
			{ nothing: "Not at all, trout, not at all", _label: "nothing" }
		}
		
		out = {}
		for choice in *choices
			key = next choice
			while key and "_" == key\sub 1, 1
				key = next choice, key

			if not SCENE.state.trout[key]
				table.insert out, choice
				
		@trout\say "Raymond parelli"
		@trout\say "A pleasure for sore eyes"
		@player\say ".%%%%%%.%%%%%%.%%%%% ok"
		@player\say "You too trout"
		@trout\say "Oh, a little charmer, arent we?"
		@trout\say ".%%%%%%.%%%%%%.%%%%%"
		@trout\say "Anyways, how may i be of service my friend?"
		res = @player\choice unpack out
		
		if res == "tonight"
			SCENE.state.trout.tonight = true
			
			@trout\say "Oh, i love it!"
			@trout\say "It will be great fun!"
			@trout\say "And to be honest with you:"
			@trout\say "I dont care if those faggots got drugs or not"
			@trout\say "I just want to smite their dirty asses"
			@trout\say "Dont get me wrong raymond"
			@trout\say "Personally i have nothing against them"
			@trout\say "But its against god"
			@trout\say "And we will do gods work tonight"
			@trout\say "You feel me raymond?"
			res = @player\choice { confirm: "Hell, lets blast those faggots of eraths face!", _label: "confirm" },
													 { deny: "Gods work?", _label: "deny" }
			if res == "confirm"
				@trout\say "Straight on raymond"
				@trout\say "I know why i like you"
				SCENE.state.trout_oppinion = "good"
			if res == "deny"
				@player\say "You mad trout?"			
				@player\say "Youre a narrow-minded fool"
				@player\say "Thats what you are"
				@trout\say ".%%%%%%.%%%%%%.%%%%%"
				SCENE.state.trout_oppinion = "bad"
				
		elseif res == "pictures"
			SCENE.state.trout.pictures = true
			
			@player\say "Do you know by any chance who took the surveillance pictures of the lovebugs club?"
			@trout\say "Oh, im terribly sorry raymond"
			@trout\say "I absolutely dont know that"
			@trout\say "But if i hear something i will tell you first"
			@trout\say ".%%%%%%.%%%%%%.%%%%%"
			@trout\say "Promise"
			@player\say ".%%%%%%.%%%%%%.%%%%%"
			@player\say "Thanks"
			@player\say "Ehm"
			@player\say "Carl..."
			
		elseif res == "nothing"
			@trout\say "Oh"
			@trout\say ".%%%%%%.%%%%%%.%%%%%"
			@trout\say "I see"
	
	elseif SCENE.state.trout_oppinion == "good"
		@trout\say "My friend, lets hit those sinners hard!"
		@player\say ".%%%%%%.%%%%%%.%%%%%"
	elseif SCENE.state.trout_oppinion == "bad"
		@trout\say "Im sad for you raymond"
		@trout\say "Very sad"
		@trout\say "I dont hate you"
		@trout\say "I just hoped you would chose the right path"
		@player\say ".%%%%%%.%%%%%%.%%%%%"