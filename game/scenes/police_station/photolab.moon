Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
	SCENE.state.photoguy = "talking"
	if SCENE.state.police == nil
		@photoguy\say "parelli, to what do i owe the honour of your visit?"
		@player\say "hi .%%%%%.%%%%%.%%%%%."
		@photoguy\say "schnitzler, joseph, but nevermind pal" 
		@photoguy\say "i only work here for two years now."
		@player\say "im sorry joseph, im really bad with names."
		@player\say "the lieutenant sent me to pick up the latest batch"
		@photoguy\say "did he? what a coincidence, isnt it?"

		res = @player\choice { confused: ".%%%%%.%%%%%.%%%%% not quite sure what you mean", _label: "confused" },
												 { nervous: "why would you say that?", _label: "nervous" },
												 { surprised: "whait.%%%%%.%%%%%.%%%%%. why?", _label: "surprised"}

		@photoguy\say "im just thinking its quite funny that you got sent down here"
		@photoguy\say "considering that you are on one of the photos outside the club talking to one of the fags"
		@photoguy\say "as far as im informed you are no undercover detective, are you?" 
		
		res = @player\choice { intimidate: "dont overstep your boundaries", _label: "intimidate" },
												 { argue: "look, i was there, so what?", _label: "argue" },
												 { beg: "please i beg you dont tell the others", _label: "beg"},
												 { bargain: "come on man, what do you need?", _label: "bargain"}
		if res == "intimidate"
			@player\say "just give me the goddamn picture!"
			@photoguy\say "%%%%%calm down! why so agitated?"
			@photoguy\say "did say i would show it to someone?"
			@photoguy\say "why would i?"
			@photoguy\say "i dont care what you do in your free time"
			@photoguy\say "but maybe you should think twice where to spend your time"
			@photoguy\say "im not the one who took the picture"
			@photoguy\say "so at least one other person has seen you."
		elseif res == "argue"
			@player\say "i can do what I want in my free time"
			@player\say "please go ahead and show it to everyone"
			@player\say "if you want to ruin my life and destroy my family!"
			@photoguy\say "%%%%%i would be the one ruining your life?"
			@photoguy\say "i would rather say that it is your own fault"
			@photoguy\say "you have decided to go down this road, pal"
			@photoguy\say "and you know what they say:"
			@photoguy\say "dont shoot the messenger"
			@photoguy\say "but hey, who am i to judge anyways?"
			@photoguy\say "maybe you should think twice where to spend your time though"
			@photoguy\say "im not the one who took the picture"
			@photoguy\say "so at least one other person has seen you."
		elseif res == "beg"
			@player\say ".%%%%%.%%%%%.%%%%% i got a family"
			@player\say ".%%%%%.%%%%%.%%%%% it would ruin me!"
			@photoguy\say "%%%%% cmon stop whining, where is your dignity?"
			@photoguy\say "you have chosen your own path man"
			@photoguy\say "but maybe you should think twice where to spend your time"
			@photoguy\say "im not the one who took the picture"
			@photoguy\say "so at least one other person has seen you."
		elseif res == "bargain"
			@player\say ".%%%%%.%%%%%.%%%%% money?"
			@player\say ".%%%%%.%%%%%.%%%%% ill do whatever"
			@player\say ".%%%%%.%%%%%.%%%%% just give me the picture."
			@photoguy\say "%%%%%You really think I’m that cheap?"
			@photoguy\say "man, where is your pride?"
			@photoguy\say "i want nothing of you!"
			@photoguy\say "never said i would"
			@photoguy\say "but maybe you should think twice where to spend your time"
			@photoguy\say "im not the one who took the picture"
			@photoguy\say "so at least one other person has seen you."
		SCENE.state.police = 1
	elseif SCENE.state.police == 1
		@photoguy\say "you stupid fuck"
	
	SCENE.state.photoguy = nil
