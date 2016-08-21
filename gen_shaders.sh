#!/bin/bash

meteor npm install glsl-blend glslify

shadergen() {
  cat <<EOF
#pragma glslify: blend = require(glsl-blend/$1)
extern Image foreground;
extern vec2 foreground_offset, foreground_size;
extern number opacity;


vec3 opacity_blend(vec3 base, vec3 front, float opacity) {
  return (blend(base, front) * opacity + base * (1.0 - opacity));
}

vec4 effect(vec4 global_color, Image background, vec2 uv, vec2 screen_coords) {
  vec4 bgColor = Texel(background, uv);
  vec4 fgColor = Texel(foreground, (screen_coords + foreground_offset)/foreground_size);

  vec3 color = opacity_blend(bgColor.rgb, fgColor.rgb, opacity * fgColor.a);

  return vec4(color, 1.0);
}
EOF
}

mkdir -p shaders
for shader in node_modules/glsl-blend/*.glsl; do
  shadergen $(basename $shader .glsl) | node_modules/.bin/glslify > shaders/$(basename $shader)
done
