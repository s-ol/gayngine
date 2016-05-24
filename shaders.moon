mapping = {
  norm: "normal"
--pass: "pass-through"
  mul:  "multiply"
  scrn: "screen"
  over: "overlay"

  diss: "dissolve"
  dark: "darken"
  idiv: "color-burn"
  lbrn: "linear-burn"
  dkCl: "darker-color"
  lite: "lighten"
  div:  "color-dodge"
  lddg: "linear-dodge"
  lgCl: "lighter-color"
  sLit: "soft-light"
  hLit: "hard-light"
  vLit: "vivid-light"
  lLit: "linear-light"
  pLit: "pin-light"
  hMix: "hard mix"
  diff: "difference"
  smud: "exclusion"
  fsub: "subtract"
  fdiv: "divide"
  hue:  "hue"
  sat:  "saturation"
  colr: "color"
  lum:  "luminosity"
}

psdShader = require "lib.artal.psdShader"
setmetatable {}, { __index: (name) =>
  pixel = love.filesystem.read "shaders/#{mapping[name]}.glsl"
  --pixel = psdShader.createShaderString "mul"
  with shader = love.graphics.newShader pixel; print "
    vec4 position(mat4 transform_projection, vec4 vertex_position) {
          return transform_projection * vertex_position;
    }"
    @[name] = shader
}
