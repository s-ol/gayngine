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
		res = @player\choice { tonight: "what can you tell me about operation lovebugs, sergeant?", _label: "about tonight" },
												 { investigator: "i need to find the one who took the pictures in the lovebug-investigation" },
												 { you: "i believe i never told you that,", _label: "about you"},
												 { nothing: "i just wanted to say that im ready for tonight!", _label: "nothing"}
