vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec3 blend(vec3 base, vec3 front) {
  vec3 hsv_base = rgb2hsv(base);
  vec3 hsv_front = rgb2hsv(front);
  return hsv2rgb(vec3(hsv_front.r, hsv_front.g, hsv_base.b));
}

extern Image foreground;
extern vec2 foreground_offset, foreground_size;
extern number opacity;

vec3 alpha_blend(vec3 base, vec3 front, float opacity) {
  return (blend(base, front) * opacity + base * (1.0 - opacity));
}

vec4 effect(vec4 global_color, Image background, vec2 uv, vec2 screen_coords) {
  vec4 bgColor = Texel(background, uv);
  vec4 fgColor = Texel(foreground, (screen_coords + foreground_offset)/foreground_size);

  vec3 color = alpha_blend(bgColor.rgb, fgColor.rgb, opacity * fgColor.a);

  return vec4(color, 1.0);
}
