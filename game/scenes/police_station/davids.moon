Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
  if SCENE.state.police == 1
		if SCENE.davids == nil
			@davids\say "parelli, the lieutenant waits for those photos"
			SCENE.davids = 1
		elseif SCENE.davids == 1
			@davids\say "%%%%%.%%%%%.%%%%%.%%%%%"

  if SCENE.state.police == 2
		@davids\say "parelli, what is it?"
		res = @player\choice { photos: "davids, i was wondering", _label: "about the photos" },
												 { operation: "davids, what do you think about operation lovebug?", _label: "about the operation" },
												 { you: "brenda i love you", _label: "about you" }
		if res == "photos"
			@davids\say "?"
		elseif res == "operation"
			@davids\say "?"
		elseif res == "you"
			@davids\say "?"