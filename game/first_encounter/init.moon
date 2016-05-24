export DIALOGUE

class Dialogue
  new: (@timeline) =>
    @current = 0

  advance: =>
    @current += 1 unless "table" == type(@timeline[@current]) and @timeline[@current].type == "choice"

  select: (index) =>
    @last_choice = index
    @current += 1

  get: (slot) =>
    text = (@timeline[@current] or {})[slot]
    if "table" == type(text) and text.type == "response"
      text = text[@last_choice]
    text

DIALOGUE = Dialogue {
  {
    hector: "what's up boyo?"
  },
  {
    hector: "do you like choices?"
  },
  {
    raymond: {
      type: "choice"
      "yes", "no", "fuck off"
    }
  },
  {
    hector: {
      type: "response",
      "great, cause you just had to make one",
      "too bad",
      "woah chill out there buddy",
    }
  },
  {
    hector: "we all have issues"
  }
}
