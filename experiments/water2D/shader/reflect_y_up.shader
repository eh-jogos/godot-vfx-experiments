shader_type canvas_item;

uniform vec4 color :hint_color;
uniform float reflection_intensity :hint_range(0.0,1.0)= 0.5;
uniform sampler2D transition_gradient :hint_black;

// Updated from GDScript
uniform float scale_y = 1.0f;
uniform float zoom_y = 1.0f;

float get_reflected_y(float uv_size_ratio_v, float current_uv_y){
	// current_uv_y * uv_size_ratio_v is the vertical distance from the top of the texture in 
	// the current sample converted to "screen units". We double it, because we want to sample 
	// that same distance above the texture, as that's what we want to "reflect". Then we multiply 
	// by texture scale and screen zoom (supplied by the script in the node) to fix any 
	// scaling or zoom issues
	return uv_size_ratio_v * current_uv_y * 2.0 * scale_y * zoom_y;
}

vec4 get_reflected_color(float texture_height, float screen_height, vec2 uv, vec2 screen_uv, sampler2D screen_texture){
	float uv_size_ratio_v = texture_height / screen_height;
	vec2 uv_reflected = vec2(screen_uv.x, screen_uv.y + get_reflected_y(uv_size_ratio_v, uv.y));
	return texture(screen_texture, uv_reflected);
}

void fragment () {
	vec4 reflected_color = get_reflected_color(
			1.0 / TEXTURE_PIXEL_SIZE.y,
			1.0 / SCREEN_PIXEL_SIZE.y,
			UV,
			SCREEN_UV,
			SCREEN_TEXTURE
	);
	
	// The gradient texture is a "one dimensional" horizontal texture, so we use 1 - UV.y  to 
	// sample it according to the vertical axis of our texture, but in the inverse direction so that
	// white is on top (we could have just used UV.y and changed the texture as well)
	float transition_mask = texture(transition_gradient, vec2(1.0 - UV.y, 1.0)).r;
	vec4 mixed_color = mix(color, reflected_color, transition_mask * reflection_intensity);
	
//	COLOR.rg = uv_reflected;
//	COLOR.rgb = vec3(uv_size_ratio_v);
	COLOR = mixed_color;
}