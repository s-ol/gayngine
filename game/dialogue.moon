DialogueSlot = require "game.scenes.common.dialogueslot"

class Dialogue
  new: (script) =>
    @script = coroutine.wrap script

  start: =>
    wrapped = {}

    for name, slot in pairs DialogueSlot.INSTANCES
      slot\clear!
      wrapped[name] = setmetatable {}, __index: (_, key) ->
        (_, ...) ->
          slot[key] slot, @, ...
          coroutine.yield!

    @.script wrapped

  next: (...) =>
    for name, slot in pairs DialogueSlot.INSTANCES
      slot\clear!
    @.script ...

{ :Dialogue }
