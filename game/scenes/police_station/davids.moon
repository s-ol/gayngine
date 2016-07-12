Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
	SCENE.state.davids or= {}

	if SCENE.state.police == 1
		if SCENE.state.davids.approached == nil
			@davids\say "parelli, the lieutenant waits for those photos"
			SCENE.state.davids.approached = true
		else SCENE.davids
			@davids\say "%%%%%.%%%%%.%%%%%.%%%%%"

	if SCENE.state.police == 2
		choices = {
			{ photos: "davids, i was wondering", _label: "about the photos" },
			{ operation: "davids, what do you think about operation lovebug?", _label: "about the operation" },
			{ you: "brenda i love you", _label: "about you" }
		}

		out = {}
		for choice in *choices
			key = next choice
			while key and "_" == key\sub 1, 1
				key = next choice, key

			if not SCENE.state.davids[key]
				table.insert out, choice

		if #out == 0 -- no more choices
			@player\say "..."
			return

		@davids\say "parelli, what is it?"
		res = @player\choice unpack out

		if res == "photos"
			SCENE.state.davids.photos = true
			@davids\say "?"
		elseif res == "operation"
			SCENE.state.davids.operation = true
			@davids\say "?"
		elseif res == "you"
			SCENE.state.davids.you = true
			@davids\say "?"
