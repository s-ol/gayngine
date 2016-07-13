function love.conf(t)
  t.identity = "gayngine"
  t.version = "0.10.1"
  t.gammacorrect = false
  t.console = true

  t.window.title = "gayngine"
  t.window.fullscreen = true
<<<<<<< HEAD
  t.window.width = 320 * 4.3
  t.window.height = 180 * 4.3
  t.window.vsync = true
=======
  t.window.width = 320 * 6
  t.window.height = 180 * 6
  t.window.vsync = false
>>>>>>> c1cacd60d78d217942323ac89b5c83283f04a3ee

  t.modules.joystick = false
  t.modules.physics = false
  t.modules.video = false
  t.modules.thread = false
end
