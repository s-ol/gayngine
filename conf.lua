function love.conf(t)
  t.identity = "twoshootingstars"
  t.version = "0.10.1"
  t.gammacorrect = false
  t.console = true

  t.window.title = "two_shooting_stars"
  t.window.fullscreen = false
  t.window.width = 320 * 6
  t.window.height = 180 * 6
  t.window.vsync = false

  t.modules.joystick = false
  t.modules.physics = false
  t.modules.video = false
  t.modules.thread = false
end
