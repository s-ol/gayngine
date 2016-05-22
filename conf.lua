function love.conf(t)
  t.identity = "gayngine"
  t.version = "0.10.1"
  t.gammacorrect = true

  t.window.title = "gayngine"
  t.window.width = 320 * 4
  t.window.height = 180 * 4

  t.modules.joystick = false
  t.modules.physics = false
  t.modules.video = false
  t.modules.thread = false
end
