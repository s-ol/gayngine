export DIALOGUE

class Dialogue
  new: (@timeline) =>
    @current = 0

  advance: =>
    @current += 1 unless @timeline[@current] and @timeline[@current].choice

  select: (index) =>
    print "selected ##{index}"
    @current += 1

  get: (slot) => (@timeline[@current] or {})[slot]

DIALOGUE = Dialogue {
  {
    hector: "what's up boyo?"
  },
  {
    hector: "do you like choices?"
  },
  {
    _choice: true
    raymond: { "yes", "no", "fuck off" }
  },
  {
    hector: "oh come on crybaby."
  },
  {
    hector: "we all have issues"
  }
}
