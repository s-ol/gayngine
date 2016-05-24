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
    hector: "hi!"
  },
  {
    raymond: "hi"
  },
  {
    hector: "what a crazy night."
  },
  {
    raymond: "uhm. yeah."
  },
  {
    hector: "..."
  },
  {
    hector: "what's troubling you?"
  },
  {
    raymond: {
      type: "choice"
      "-my life is a mess", "-problems at work", "-nothing"
    }
  },
  {
    raymond: {
      type: "response"
      "my life is a fucking mess", "it's just about work.", "it's nothing important."
    }
  },
  {
    hector: {
      type: "response",
      "whose isn't? all of us fools have something to chew on.",
      "not surprised. all of us fools have something to chew on",
      "it's always important. especially if you're the type that hangs around here.",
    }
  },
  {
    raymond: "what do you mean?"
  },
  {
    hector: "hey look around. everybody here is a misfit weirdo."
  },
  {
    hector: "if you have problems, this is the place where you find someone to share it with."
  },
  {
    raymond: "now you're clearly suggesting that someone is you."
  },
  {
    hector: "i'm not. but i believe i am qualified."
  }
}
