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

setmetatable {}, { __index: (name) =>
  pixel = love.filesystem.read "shaders/#{mapping[name]}.glsl"
  with shader = love.graphics.newShader pixel
    @[name] = shader
}
