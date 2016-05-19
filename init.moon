{graphics: lg, keyboard: lk, mouse: lm, audio: la, event: le} = love

export ^

Width, Height = lg.getDimensions!

love.keypressed = (key) ->
  switch key
    when "escape"
      le.push "quit"
