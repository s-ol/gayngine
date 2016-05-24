#define GLSLIFY 1
float blendColorDodge(float base, float blend) {
	return (blend==1.0)?blend:min(base/(1.0-blend),1.0);
}

vec3 blendColorDodge(vec3 base, vec3 blend) {
	return vec3(blendColorDodge(base.r,blend.r),blendColorDodge(base.g,blend.g),blendColorDodge(base.b,blend.b));
}

vec3 blendColorDodge(vec3 base, vec3 blend, float opacity) {
	return (blendColorDodge(base, blend) * opacity + blend * (1.0 - opacity));
}

float blendColorBurn(float base, float blend) {
	return (blend==0.0)?blend:max((1.0-((1.0-base)/blend)),0.0);
}

vec3 blendColorBurn(vec3 base, vec3 blend) {
	return vec3(blendColorBurn(base.r,blend.r),blendColorBurn(base.g,blend.g),blendColorBurn(base.b,blend.b));
}

vec3 blendColorBurn(vec3 base, vec3 blend, float opacity) {
	return (blendColorBurn(base, blend) * opacity + blend * (1.0 - opacity));
}

float blendVividLight(float base, float blend) {
	return (blend<0.5)?blendColorBurn(base,(2.0*blend)):blendColorDodge(base,(2.0*(blend-0.5)));
}

vec3 blendVividLight(vec3 base, vec3 blend) {
	return vec3(blendVividLight(base.r,blend.r),blendVividLight(base.g,blend.g),blendVividLight(base.b,blend.b));
}

vec3 blendVividLight(vec3 base, vec3 blend, float opacity) {
	return (blendVividLight(base, blend) * opacity + blend * (1.0 - opacity));
}

float blendHardMix(float base, float blend) {
	return (blendVividLight(base,blend)<0.5)?0.0:1.0;
}

vec3 blendHardMix(vec3 base, vec3 blend) {
	return vec3(blendHardMix(base.r,blend.r),blendHardMix(base.g,blend.g),blendHardMix(base.b,blend.b));
}

vec3 blendHardMix(vec3 base, vec3 blend, float opacity) {
	return (blendHardMix(base, blend) * opacity + blend * (1.0 - opacity));
}

float blendLinearDodge(float base, float blend) {
	// Note : Same implementation as BlendAddf
	return min(base+blend,1.0);
}

vec3 blendLinearDodge(vec3 base, vec3 blend) {
	// Note : Same implementation as BlendAdd
	return min(base+blend,vec3(1.0));
}

vec3 blendLinearDodge(vec3 base, vec3 blend, float opacity) {
	return (blendLinearDodge(base, blend) * opacity + blend * (1.0 - opacity));
}

float blendLinearBurn(float base, float blend) {
	// Note : Same implementation as BlendSubtractf
	return max(base+blend-1.0,0.0);
}

vec3 blendLinearBurn(vec3 base, vec3 blend) {
	// Note : Same implementation as BlendSubtract
	return max(base+blend-vec3(1.0),vec3(0.0));
}

vec3 blendLinearBurn(vec3 base, vec3 blend, float opacity) {
	return (blendLinearBurn(base, blend) * opacity + blend * (1.0 - opacity));
}

float blendLinearLight(float base, float blend) {
	return blend<0.5?blendLinearBurn(base,(2.0*blend)):blendLinearDodge(base,(2.0*(blend-0.5)));
}

vec3 blendLinearLight(vec3 base, vec3 blend) {
	return vec3(blendLinearLight(base.r,blend.r),blendLinearLight(base.g,blend.g),blendLinearLight(base.b,blend.b));
}

vec3 blendLinearLight(vec3 base, vec3 blend, float opacity) {
	return (blendLinearLight(base, blend) * opacity + blend * (1.0 - opacity));
}

float blendLighten(float base, float blend) {
	return max(blend,base);
}

vec3 blendLighten(vec3 base, vec3 blend) {
	return vec3(blendLighten(base.r,blend.r),blendLighten(base.g,blend.g),blendLighten(base.b,blend.b));
}

vec3 blendLighten(vec3 base, vec3 blend, float opacity) {
	return (blendLighten(base, blend) * opacity + blend * (1.0 - opacity));
}

float blendDarken(float base, float blend) {
	return min(blend,base);
}

vec3 blendDarken(vec3 base, vec3 blend) {
	return vec3(blendDarken(base.r,blend.r),blendDarken(base.g,blend.g),blendDarken(base.b,blend.b));
}

vec3 blendDarken(vec3 base, vec3 blend, float opacity) {
	return (blendDarken(base, blend) * opacity + blend * (1.0 - opacity));
}

float blendPinLight(float base, float blend) {
	return (blend<0.5)?blendDarken(base,(2.0*blend)):blendLighten(base,(2.0*(blend-0.5)));
}

vec3 blendPinLight(vec3 base, vec3 blend) {
	return vec3(blendPinLight(base.r,blend.r),blendPinLight(base.g,blend.g),blendPinLight(base.b,blend.b));
}

vec3 blendPinLight(vec3 base, vec3 blend, float opacity) {
	return (blendPinLight(base, blend) * opacity + blend * (1.0 - opacity));
}

float blendReflect(float base, float blend) {
	return (blend==1.0)?blend:min(base*base/(1.0-blend),1.0);
}

vec3 blendReflect(vec3 base, vec3 blend) {
	return vec3(blendReflect(base.r,blend.r),blendReflect(base.g,blend.g),blendReflect(base.b,blend.b));
}

vec3 blendReflect(vec3 base, vec3 blend, float opacity) {
	return (blendReflect(base, blend) * opacity + blend * (1.0 - opacity));
}

vec3 blendGlow(vec3 base, vec3 blend) {
	return blendReflect(blend,base);
}

vec3 blendGlow(vec3 base, vec3 blend, float opacity) {
	return (blendGlow(base, blend) * opacity + blend * (1.0 - opacity));
}

float blendOverlay(float base, float blend) {
	return base<0.5?(2.0*base*blend):(1.0-2.0*(1.0-base)*(1.0-blend));
}

vec3 blendOverlay(vec3 base, vec3 blend) {
	return vec3(blendOverlay(base.r,blend.r),blendOverlay(base.g,blend.g),blendOverlay(base.b,blend.b));
}

vec3 blendOverlay(vec3 base, vec3 blend, float opacity) {
	return (blendOverlay(base, blend) * opacity + blend * (1.0 - opacity));
}

vec3 blendHardLight(vec3 base, vec3 blend) {
	return blendOverlay(blend,base);
}

vec3 blendHardLight(vec3 base, vec3 blend, float opacity) {
	return (blendHardLight(base, blend) * opacity + blend * (1.0 - opacity));
}

vec3 blendPhoenix(vec3 base, vec3 blend) {
	return min(base,blend)-max(base,blend)+vec3(1.0);
}

vec3 blendPhoenix(vec3 base, vec3 blend, float opacity) {
	return (blendPhoenix(base, blend) * opacity + blend * (1.0 - opacity));
}

vec3 blendNormal(vec3 base, vec3 blend) {
	return blend;
}

vec3 blendNormal(vec3 base, vec3 blend, float opacity) {
	return (blendNormal(base, blend) * opacity + blend * (1.0 - opacity));
}

vec3 blendNegation(vec3 base, vec3 blend) {
	return vec3(1.0)-abs(vec3(1.0)-base-blend);
}

vec3 blendNegation(vec3 base, vec3 blend, float opacity) {
	return (blendNegation(base, blend) * opacity + blend * (1.0 - opacity));
}

vec3 blendMultiply(vec3 base, vec3 blend) {
	return base*blend;
}

vec3 blendMultiply(vec3 base, vec3 blend, float opacity) {
	return (blendMultiply(base, blend) * opacity + blend * (1.0 - opacity));
}

vec3 blendAverage(vec3 base, vec3 blend) {
	return (base+blend)/2.0;
}

vec3 blendAverage(vec3 base, vec3 blend, float opacity) {
	return (blendAverage(base, blend) * opacity + blend * (1.0 - opacity));
}

float blendScreen(float base, float blend) {
	return 1.0-((1.0-base)*(1.0-blend));
}

vec3 blendScreen(vec3 base, vec3 blend) {
	return vec3(blendScreen(base.r,blend.r),blendScreen(base.g,blend.g),blendScreen(base.b,blend.b));
}

vec3 blendScreen(vec3 base, vec3 blend, float opacity) {
	return (blendScreen(base, blend) * opacity + blend * (1.0 - opacity));
}

float blendSoftLight(float base, float blend) {
	return (blend<0.5)?(2.0*base*blend+base*base*(1.0-2.0*blend)):(sqrt(base)*(2.0*blend-1.0)+2.0*base*(1.0-blend));
}

vec3 blendSoftLight(vec3 base, vec3 blend) {
	return vec3(blendSoftLight(base.r,blend.r),blendSoftLight(base.g,blend.g),blendSoftLight(base.b,blend.b));
}

vec3 blendSoftLight(vec3 base, vec3 blend, float opacity) {
	return (blendSoftLight(base, blend) * opacity + blend * (1.0 - opacity));
}

float blendSubtract(float base, float blend) {
	return max(base+blend-1.0,0.0);
}

vec3 blendSubtract(vec3 base, vec3 blend) {
	return max(base+blend-vec3(1.0),vec3(0.0));
}

vec3 blendSubtract(vec3 base, vec3 blend, float opacity) {
	return (blendSubtract(base, blend) * opacity + blend * (1.0 - opacity));
}

vec3 blendExclusion(vec3 base, vec3 blend) {
	return base+blend-2.0*base*blend;
}

vec3 blendExclusion(vec3 base, vec3 blend, float opacity) {
	return (blendExclusion(base, blend) * opacity + blend * (1.0 - opacity));
}

vec3 blendDifference(vec3 base, vec3 blend) {
	return abs(base-blend);
}

vec3 blendDifference(vec3 base, vec3 blend, float opacity) {
	return (blendDifference(base, blend) * opacity + blend * (1.0 - opacity));
}

float blendAdd(float base, float blend) {
	return min(base+blend,1.0);
}

vec3 blendAdd(vec3 base, vec3 blend) {
	return min(base+blend,vec3(1.0));
}

vec3 blendAdd(vec3 base, vec3 blend, float opacity) {
	return (blendAdd(base, blend) * opacity + blend * (1.0 - opacity));
}

vec3 blendMode( int mode, vec3 base, vec3 blend ){
	if( mode == 1 ){
		return blendAdd( base, blend );
	}else
	if( mode == 2 ){
		return blendAverage( base, blend );
	}else
	if( mode == 3 ){
		return blendColorBurn( base, blend );
	}else
	if( mode == 4 ){
		return blendColorDodge( base, blend );
	}else
	if( mode == 5 ){
		return blendDarken( base, blend );
	}else
	if( mode == 6 ){
		return blendDifference( base, blend );
	}else
	if( mode == 7 ){
		return blendExclusion( base, blend );
	}else
	if( mode == 8 ){
		return blendGlow( base, blend );
	}else
	if( mode == 9 ){
		return blendHardLight( base, blend );
	}else
	if( mode == 10 ){
		return blendHardMix( base, blend );
	}else
	if( mode == 11 ){
		return blendLighten( base, blend );
	}else
	if( mode == 12 ){
		return blendLinearBurn( base, blend );
	}else
	if( mode == 13 ){
		return blendLinearDodge( base, blend );
	}else
	if( mode == 14 ){
		return blendLinearLight( base, blend );
	}else
	if( mode == 15 ){
		return blendMultiply( base, blend );
	}else
	if( mode == 16 ){
		return blendNegation( base, blend );
	}else
	if( mode == 17 ){
		return blendNormal( base, blend );
	}else
	if( mode == 18 ){
		return blendOverlay( base, blend );
	}else
	if( mode == 19 ){
		return blendPhoenix( base, blend );
	}else
	if( mode == 20 ){
		return blendPinLight( base, blend );
	}else
	if( mode == 21 ){
		return blendReflect( base, blend );
	}else
	if( mode == 22 ){
		return blendScreen( base, blend );
	}else
	if( mode == 23 ){
		return blendSoftLight( base, blend );
	}else
	if( mode == 24 ){
		return blendSubtract( base, blend );
	}else
	if( mode == 25 ){
		return blendVividLight( base, blend );
	}
}

vec3 blendMode( int mode, vec3 base, vec3 blend, float opacity ){
	if( mode == 1 ){
		return blendAdd( base, blend, opacity );
	}else
	if( mode == 2 ){
		return blendAverage( base, blend, opacity );
	}else
	if( mode == 3 ){
		return blendColorBurn( base, blend, opacity );
	}else
	if( mode == 4 ){
		return blendColorDodge( base, blend, opacity );
	}else
	if( mode == 5 ){
		return blendDarken( base, blend, opacity );
	}else
	if( mode == 6 ){
		return blendDifference( base, blend, opacity );
	}else
	if( mode == 7 ){
		return blendExclusion( base, blend, opacity );
	}else
	if( mode == 8 ){
		return blendGlow( base, blend, opacity );
	}else
	if( mode == 9 ){
		return blendHardLight( base, blend, opacity );
	}else
	if( mode == 10 ){
		return blendHardMix( base, blend, opacity );
	}else
	if( mode == 11 ){
		return blendLighten( base, blend, opacity );
	}else
	if( mode == 12 ){
		return blendLinearBurn( base, blend, opacity );
	}else
	if( mode == 13 ){
		return blendLinearDodge( base, blend, opacity );
	}else
	if( mode == 14 ){
		return blendLinearLight( base, blend, opacity );
	}else
	if( mode == 15 ){
		return blendMultiply( base, blend, opacity );
	}else
	if( mode == 16 ){
		return blendNegation( base, blend, opacity );
	}else
	if( mode == 17 ){
		return blendNormal( base, blend, opacity );
	}else
	if( mode == 18 ){
		return blendOverlay( base, blend, opacity );
	}else
	if( mode == 19 ){
		return blendPhoenix( base, blend, opacity );
	}else
	if( mode == 20 ){
		return blendPinLight( base, blend, opacity );
	}else
	if( mode == 21 ){
		return blendReflect( base, blend, opacity );
	}else
	if( mode == 22 ){
		return blendScreen( base, blend, opacity );
	}else
	if( mode == 23 ){
		return blendSoftLight( base, blend, opacity );
	}else
	if( mode == 24 ){
		return blendSubtract( base, blend, opacity );
	}else
	if( mode == 25 ){
		return blendVividLight( base, blend, opacity );
	}
}

extern Image foreground;
extern vec2 foreground_offset, foreground_size;
extern number opacity;

vec3 opacity_blend(vec3 base, vec3 front, float opacity) {
  return (blendMode(base, front) * opacity + base * (1.0 - opacity));
}

vec4 effect(vec4 global_color, Image background, vec2 uv, vec2 screen_coords) {
  vec4 bgColor = Texel(background, uv);
  vec4 fgColor = Texel(foreground, (screen_coords + foreground_offset)/foreground_size);

  vec3 color = opacity_blend(bgColor.rgb, fgColor.rgb, opacity * fgColor.a);

  return vec4(color, 1.0);
}
