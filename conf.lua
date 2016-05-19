function love.conf(t)
  t.identity = "rhythmn-rampage"
  t.version = "0.10.1"
  t.accelerometerjoystick = true
  t.gammacorrect = true

  t.window.title = "Rhytmn Rampage WIP"
  t.window.width = 1200
  t.window.height = 600

  t.modules.joystick = false
  t.modules.physics = false
  t.modules.video = false
  t.modules.thread = false
end
