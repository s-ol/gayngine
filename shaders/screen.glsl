#define GLSLIFY 1
float blendScreen(float base, float blend) {
	return 1.0-((1.0-base)*(1.0-blend));
}

vec3 blendScreen(vec3 base, vec3 blend) {
	return vec3(blendScreen(base.r,blend.r),blendScreen(base.g,blend.g),blendScreen(base.b,blend.b));
}

vec3 blendScreen(vec3 base, vec3 blend, float opacity) {
	return (blendScreen(base, blend) * opacity + blend * (1.0 - opacity));
}

extern Image foreground;
extern vec2 foreground_offset, foreground_size;
extern number opacity;

vec3 opacity_blend(vec3 base, vec3 front, float opacity) {
  return (blendScreen(base, front) * opacity + base * (1.0 - opacity));
}

vec4 effect(vec4 global_color, Image background, vec2 uv, vec2 screen_coords) {
  vec4 bgColor = Texel(background, uv);
  vec4 fgColor = Texel(foreground, (screen_coords + foreground_offset)/foreground_size);

  vec3 color = opacity_blend(bgColor.rgb, fgColor.rgb, opacity * fgColor.a);

  return vec4(color, 1.0);
}
