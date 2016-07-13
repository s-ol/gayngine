function love.conf(t)
  t.identity = "gayngine"
  t.version = "0.10.1"
  t.gammacorrect = false
  t.console = true

  t.window.title = "gayngine"
  t.window.fullscreen = true
  t.window.width = 320 * 6
  t.window.height = 180 * 6
  t.window.vsync = true

  t.modules.joystick = false
  t.modules.physics = false
  t.modules.video = false
  t.modules.thread = false
end
