DialogueSlot = require "game.scenes.common.dialogueslot"

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

    coroutine.resume @routine, wrapped

  next: (...) =>
    for name, slot in pairs DialogueSlot.INSTANCES
      slot\clear!
    coroutine.resume @routine, ...

{ :Dialogue }
