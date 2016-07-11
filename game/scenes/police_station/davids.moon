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
		elseif SCENE.davids
			@davids\say "%%%%%.%%%%%.%%%%%.%%%%%"

	if SCENE.state.police == 2
		choices = {
			photos: { "davids, i was wondering", _label: "about the photos" },
			operation: { "davids, what do you think about operation lovebug?", _label: "about the operation" },
			you: { "brenda i love you", _label: "about you" }
		}

		out = for key, choice in pairs choices
			if SCENE.state.davids[key]
				continue

			choice[key] = choice[1]
			choice[1] = nil
			choice

		if #out == 0 -- no more choices
			@player\say "..."
			return

		@davids\say "parelli, what is it?"
		res = @player\choice unpack out

		if res == "photos"
			SCENE.state.davids.photos = true
			@davids\say "?"
		if res == "operation"
			SCENE.state.davids.operation = true
			@davids\say "?"
		if res == "you"
			SCENE.state.davids.you = true
			@davids\say "?"
