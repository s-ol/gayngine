Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
	SCENE.state.schnitzler = "talking"
	if SCENE.state.police == nil
		@schnitzler\say "parelli, to what do i owe the honour of your visit?"
		@player\say "hi .%%%%%.%%%%%.%%%%%.%%%%%.%%%%%.%%%%%."
		@player\say "sorry, what was your name again?"
		@schnitzler\say "schnitzler, joseph, but nevermind pal"
		@schnitzler\say "ive only been working here for two years now."
		@player\say "im sorry joseph, im really bad with names."
		@player\say "the lieutenant sent me to pick up the latest batch"
		@schnitzler\say "did he? what a coincidence, isnt it?"

		res = @player\choice { confused: ".%%%%%.%%%%%.%%%%% not quite sure what you mean", _label: "confused" },
												 { nervous: "why would you say that?", _label: "nervous" },
												 { surprised: "whait.%%%%%.%%%%%.%%%%%. why?", _label: "surprised"}

		@schnitzler\say "im just thinking its quite funny that you got sent down here"
		@schnitzler\say "considering that you are on one of the photos outside the club talking to one of the fags"
		@schnitzler\say "as far as im informed you are not an undercover detective, are you?" 
		
		res = @player\choice { intimidate: "dont overstep your boundaries", _label: "intimidate" },
												 { argue: "look, i was there, so what?", _label: "argue" },
												 { beg: "please, i beg you, dont tell anyone", _label: "beg"},
												 { bargain: "come on man, what do you need?", _label: "bargain"}
		if res == "intimidate"
			@player\say "just give me the goddamn picture!"
			@schnitzler\say "%%%%%calm down! why so agitated?"
			@schnitzler\say "did say i would show it to someone?"
			@schnitzler\say "why would i?"
			@schnitzler\say "i dont care what you do in your free time"
			@schnitzler\say "but maybe you should think twice about where you spend your time"
			@schnitzler\say "im not the one who took the picture"
			@schnitzler\say "so at least one other person has seen you."
		elseif res == "argue"
			@player\say "i can do what I want in my free time"
			@player\say "please go ahead and show it to everyone..."
			@player\say "if you want to ruin my life and destroy my family!"
			@schnitzler\say "%%%%%i would be the one ruining your life?"
			@schnitzler\say "i would rather say that it is your own fault"
			@schnitzler\say "you have decided to go down this road, pal"
			@schnitzler\say "and you know what they say:"
			@schnitzler\say "dont shoot the messenger"
			@schnitzler\say "but hey, who am i to judge anyways?"
			@schnitzler\say "maybe you should think twice about where you spend your time though"
			@schnitzler\say "im not the one who took the picture"
			@schnitzler\say "so at least one other person has seen you."
		elseif res == "beg"
			@player\say ".%%%%%.%%%%%.%%%%% i have a family"
			@player\say ".%%%%%.%%%%%.%%%%% it would ruin me!"
			@schnitzler\say "%%%%% cmon stop whining, where is your dignity?"
			@schnitzler\say "you have chosen your own path man"
			@schnitzler\say "but maybe you should think twice about where you spend your time"
			@schnitzler\say "im not the one who took the picture"
			@schnitzler\say "so at least one other person has seen you."
		elseif res == "bargain"
			@player\say ".%%%%%.%%%%%.%%%%% money?"
			@player\say ".%%%%%.%%%%%.%%%%% ill do whatever"
			@player\say ".%%%%%.%%%%%.%%%%% just give me the picture."
			@schnitzler\say "%%%%%You really think I’m that cheap?"
			@schnitzler\say "man, where is your pride?"
			@schnitzler\say "i want nothing of you!"
			@schnitzler\say "never said i would"
			@schnitzler\say "but maybe you should think twice about where you spend your time"
			@schnitzler\say "im not the one who took the picture"
			@schnitzler\say "so at least one other person has seen you."
		
		@comment\say "Finally, he gave me the pictures..."
		@comment\say "But he is right, next time i have to be more careful"
		@comment\say "And for now i have to find out who took those pictures"
		@comment\say "I sure hope he doesnt remeber my face"
		@comment\say ".%%%%%.%%%%%.%%%%%"
		
		SCENE.state.police = 1
	elseif SCENE.state.police == 1
		@schnitzler\say "now go and deliver those photos, would you?"
	
	SCENE.state.schnitzler = idle
