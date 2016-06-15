Slot = require "game.scenes.common.slot"
import Dialogue from require "game.dialogue"

levels = {
  "police_station.upper",
  "police_station",
  "police_station.basement",
}

selection = Dialogue =>
  local index
  for i, level in ipairs levels
    print level, SCENE.scene
    if level == SCENE.scene
      index = i
      break

  above = levels[index - 1]
  below = levels[index + 1]

  choices = {}
  table.insert choices, {[above]: "go upstairs"} if above
  table.insert choices, {[below]: "go downstairs"} if below
  table.insert choices, {cancel: "cancel"}
  MOON.p choices

  destination = @slot\rchoice choices
  SCENE.tags.player\moveTo SCENE\unproject_3d(@playerpos), ->
    SCENE\transition_to destination unless destination == "cancel"

wrapping_ class Staircase extends Mixin
  new: (scene) =>
    super!

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
    selection\start slot: @slot, playerpos: @playerpos

  draw: (draw_group, draw_layer) =>
    draw_group { @slot }