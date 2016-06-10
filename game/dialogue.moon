DialogueSlot = require "game.scenes.common.dialogueslot"

export DIALOGUE

class Dialogue
  new: (@script) =>

  start: =>
    @routine = coroutine.create @script

    wrapped = {}
    for name, slot in pairs DialogueSlot.INSTANCES
      slot\clear!
      wrapped[name] = setmetatable {}, __index: (_, key) ->
        (_, ...) ->
          slot[key] slot, @, ...
          coroutine.yield!

    DIALOGUE = @

    coroutine.resume @routine, wrapped

    if "dead" == coroutine.status @routine
      DIALOGUE = nil

  next: (...) =>
    for name, slot in pairs DialogueSlot.INSTANCES
      slot\clear!
    coroutine.resume @routine, ...

    if "dead" == coroutine.status @routine
      DIALOGUE = nil

{ :Dialogue }
