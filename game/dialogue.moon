Slot = require "game.scenes.common.slot"

export DIALOGUE

class Dialogue
  new: (@script) =>

  start: (slots={}) =>
    @routine = coroutine.create @script

    for name, slot in pairs Slot.INSTANCES
      slot\clear!
      slots[name] = slot

    DIALOGUE = @

    coroutine.resume @routine, slots

    if "dead" == coroutine.status @routine
      DIALOGUE = nil

  next: (...) =>
    for name, slot in pairs Slot.INSTANCES
      slot\clear!

    coroutine.resume @routine, ...

    if "dead" == coroutine.status @routine
      DIALOGUE = nil

{ :Dialogue }
