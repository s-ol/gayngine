Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
  if SCENE.state.police == nil
		@receptionist\say "'ill be back in 10'"
		@receptionist\say "-kimberly clark"
  elseif SCENE.state.police == 1
		@receptionist\say "one moment"
		@player\say ".%%%.%%%.%%%"
  elseif SCENE.state.police == 2
		@receptionist\say "one moment"
		@player\say ".%%%.%%%.%%%"
  elseif SCENE.state.police == 3
		@player\say "kimberly, you look lovely today"
		@receptionist\say "come to the point parelli, some people have to be working."
		@player\say "i need an info and im not sure who is responsible"
		@player\say "i need to find out which investigator did the lovebug surveillance"
		@receptionist\say "why would you want to know that?"
		res = @player\choice { negatives: "i just got the pictures from the lab", _label: "missing negatives" },
												 { personal: "well, i started to do a bit of photographing myself", _label: "personal interest"},
												 { business: "look sweetheart, just tell me who it was", _label: "none of your business"}
		if res == "negatives"
			
			@player\say "but schnitzler, the photoguy, said a full set of negatives went missing"
			@player\say "so he asked me to find the guy who is responsible for them"
			@receptionist\say "again?.%%%.%%%."
			@receptionist\say "ok let me think"
			@receptionist\say "we have quite a few personal investigators working for the department"
			@receptionist\say "and i certainly dont know them all"
			@receptionist\say "but as far as i know there is a list with names in the archives"
			@receptionist\say "maybe you ask leo spiegel, he is usually up there"
			@receptionist\say "im sure he knows more about it"
			@player\say "thanks a bunch"
			
			@description\say "You just learned that leonard spiegel in the archieves might know more about the investigator who took the picture"
			
			SCENE.state.police = 4
			SCENE.state.receptionist = nil
			
		elseif res == "personal"
			
			@player\say "and when i saw the pictures"
			@player\say "w%%%o%%%w"
			@player\say "i mean, real masterpieces"
			@player\say "i would love to talk to the genius who took them"
			@receptionist\say "you?"
			@receptionist\say "a photographer?"
			@receptionist\say "what do even want to make pictures of?"
			@receptionist\say "your collection of empty beer bottles?"
			@receptionist\say ".%%%.%%%.%%%"
			@receptionist\say "but ok, because its you"
			@receptionist\say "as far as i know there is a list with names in the archives"
			@receptionist\say "maybe you ask leo spiegel, he is usually up there"
			@receptionist\say "im sure he knows more about it"
			@player\say "thanks a bunch"
			
			@description\say "You just learned that leonard spiegel in the archieves might know more about the investigator who took the picture"
			
			SCENE.state.police = 4
			SCENE.state.receptionist = nil
			
		elseif res == "business"
			
			@player\say "i do my job you do yours, ok?"
			@receptionist\say "excuse me?"
			@receptionist\say "i was just asking"
			@receptionist\say "ask leo spiegel in the archieves"
			@receptionist\say "maybe he knows something"
			
			@description\say "You just learned that leonard spiegel in the archieves might know more about the investigator who took the picture"
			
			SCENE.state.police = 4
			SCENE.state.receptionist = nil
		
	elseif SCENE.state.police >= 4
		@receptionist\say "one moment"
		@player\say ".%%%.%%%.%%%"
