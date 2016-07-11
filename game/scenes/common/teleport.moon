import wrapping_, Mixin from  require "util"
import Dialogue from require "game.dialogue"
Vector = require "lib.hump.vector"

vector = Vector!

wrapping_ class Teleporter extends Mixin
	new: (scene, text, name, destination) =>
		super!

		if not destination
			text, name, destination = nil, text, name

		@dialogue = Dialogue =>
			choices = {
				{go: "go #{name}"}
				{cancel: "cancel"}
			}

			@player\say text if text
			res = @player\rchoice choices
			if res == "go"
				SCENE.tags.player\moveTo SCENE\unproject_3d(@playerpos), ->
					SCENE\transition_to destination


		points = {}
		for point in *@mask.paths[1]
			points[#points+1] =  point.cp.x
			points[#points+1] =  point.cp.y

		@hitarea = scene.hit\polygon unpack points
		@hitarea.mousepressed = @\mousepressed
		@hitarea.prio = 0

		local player, slot
		for layer in *@
			if layer.name == "player"
				player = layer
			elseif layer.name\match "slot%(%)"
				@slot = layer

		@playerpos = vector.clone player.mask.paths[1][1].cp
		@playerdir = vector.clone(player.mask.paths[1][2].cp) - @playerpos

	mousepressed: =>
		@dialogue\start player: @slot, playerpos: @playerpos

	draw: (draw_group, draw_layer) =>
		draw_group { @slot }
