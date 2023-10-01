shader_type canvas_item;
uniform sampler2D image: hint_black;


vec4 multiply(vec4 base, vec4 blend){
	return base * blend;
}

vec4 screen(vec4 base, vec4 blend){
	return 1.0 - (1.0 - base) * (1.0 - blend);
}

vec4 darken(vec4 base, vec4 blend){
	return min(base, blend);
}

vec4 lighten(vec4 base, vec4 blend){
	return max(base, blend);
}

vec4 difference(vec4 base, vec4 blend){
	return abs(base - blend);
}

vec4 exclusion(vec4 base, vec4 blend){
	return base + blend - 2.0 * base * blend;
}

vec4 overlay(vec4 base, vec4 blend){
	vec4 limit = step(0.5, base);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}

vec4 hard_light(vec4 base, vec4 blend){
	vec4 limit = step(0.5, blend);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}

vec4 soft_light(vec4 base, vec4 blend){
	vec4 limit = step(0.5, blend);
	return mix(2.0 * base * blend + base * base * (1.0 - 2.0 * blend), sqrt(base) * (2.0 * blend - 1.0) + (2.0 * base) * (1.0 - blend), limit);
}

vec4 color_dodge(vec4 base, vec4 blend){
	return base / (1.0 - blend);
}

vec4 linear_dodge(vec4 base, vec4 blend){
	return base + blend;
}

vec4 color_burn(vec4 base, vec4 blend){
	return 1.0 - (1.0 - base) / blend;
}

vec4 linear_burn (vec4 base, vec4 blend)
{
	return base + blend - 1.0;
}

//uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	//vec4 a = texture(TEXTURE, UV);
	//vec4 b = texture( image, vec2(UV.x,1.0 - UV.y));
	// COLOR = a;
	//COLOR = darken(a, b);

	
	vec4 spriteColor = texture(TEXTURE, UV);
	//vec4 backgroundColor = texture(screen_texture, UV);
	vec4 c = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
//	vec3 c = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;	
		
	
	COLOR = darken(spriteColor, c);
	//COLOR = spriteColor * backgroundColor;
}
