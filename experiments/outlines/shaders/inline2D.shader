shader_type canvas_item;

uniform vec4 line_color: hint_color = vec4(1.0); // White
uniform float line_thikness: hint_range(0.0, 20.0) = 1.0;

vec4 get_inlined_texture(vec2 texture_pixel_size, sampler2D img, vec2 uv, vec4 color){
	vec2 line_size_in_units = texture_pixel_size * line_thikness;
	
	// We are sampling around the current uv position in all 8 directions and 
	// self multiplying the results
	float outline_sample = texture(img, uv + vec2(-line_size_in_units.x, 0)).a;
	outline_sample *= texture(img, uv + vec2(-line_size_in_units.x, line_size_in_units.y)).a;
	outline_sample *= texture(img, uv + vec2(0, line_size_in_units.y)).a;
	outline_sample *= texture(img, uv + vec2(line_size_in_units.x, line_size_in_units.y)).a;
	outline_sample *= texture(img, uv + vec2(line_size_in_units.x, 0)).a;
	outline_sample *= texture(img, uv + vec2(line_size_in_units.x, -line_size_in_units.y)).a;
	outline_sample *= texture(img, uv + vec2(0, -line_size_in_units.y)).a;
	outline_sample *= texture(img, uv + vec2(-line_size_in_units.x, -line_size_in_units.y)).a;
	
	// Then we get the "inverse product" of the samples (???)
	// The middle wil be transparent because theresult of this will be 0
	// The outside will be fully opaque
	// The edges will have some other value
	float outline_alpha = 1.0 - outline_sample;
	
	// Since inside is 0 and outside is 1 we "mask" the image by multiplying the alphas
	float outline_mask = outline_alpha * color.a;
	vec4 inlined_texture = mix(color, line_color, outline_mask);
	return inlined_texture;
}

void fragment(){
	// Now we draw the outline in the current UV position, according to what we sampled
	vec4 color = texture(TEXTURE, UV);
	vec4 inlined_texture = get_inlined_texture(TEXTURE_PIXEL_SIZE, TEXTURE, UV, color);
	COLOR = inlined_texture;
}