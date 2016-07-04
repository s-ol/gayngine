import wrapping_, Mixin from  require "util"
import Dialogue from require "game.dialogue"
Vector = require "lib.hump.vector"

vector = Vector!

selection = Dialogue =>
  stage = SCENE.state.police or 0

  levels = {
    if stage >= 2 then "police_station.upper-next" else "police_station.upper",
    if stage >= 1 then "police_station.main-next" else "police_station",
    "police_station.basement",
  }

  local index
  for i, level in ipairs levels
    if level == SCENE.scene
      index = i
      break

  above = levels[index - 1]
  below = levels[index + 1]

  choices = {}
  table.insert choices, {[above]: "go upstairs"} if above
  table.insert choices, {[below]: "go downstairs"} if below
  table.insert choices, {cancel: "cancel"}

  destination = @slot\rchoice choices
  if destination and destination != "cancel"
    SCENE.tags.player\moveTo SCENE\unproject_3d(@playerpos), ->
      SCENE\transition_to destination

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
