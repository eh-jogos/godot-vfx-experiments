shader_type canvas_item;

uniform vec4 line_color: hint_color = vec4(1.0); // White
uniform float line_thickness: hint_range(0.0, 20.0) = 1.0;

vec4 get_outlined_texture(vec2 texture_pixel_size, sampler2D img, vec2 uv, vec4 color){
	vec2 line_size_in_units = texture_pixel_size * line_thickness;
	
	// We are sampling around the current UV position in all 8 directions and 
	// self adding the results
	float outline_sample = texture(img, uv + vec2(-line_size_in_units.x, 0)).a;
	outline_sample += texture(img, uv + vec2(-line_size_in_units.x, line_size_in_units.y)).a;
	outline_sample += texture(img, uv + vec2(0, line_size_in_units.y)).a;
	outline_sample += texture(img, uv + vec2(line_size_in_units.x, line_size_in_units.y)).a;
	outline_sample += texture(img, uv + vec2(line_size_in_units.x, 0)).a;
	outline_sample += texture(img, uv + vec2(line_size_in_units.x, -line_size_in_units.y)).a;
	outline_sample += texture(img, uv + vec2(0, -line_size_in_units.y)).a;
	outline_sample += texture(img, uv + vec2(-line_size_in_units.x, -line_size_in_units.y)).a;
	
	float outline_alpha = min(outline_sample, 1.0);
	
	// We subtract the alpha of the texture because if we are over an area of the image that is
	// already fully opaque, we want the outline to be transparent, or "masked"
	float outline_mask = outline_alpha - color.a;
	
	vec4 outlined_texture = mix(color, line_color, outline_mask);
	return outlined_texture;
}

void fragment(){
	// Now we draw the outline in the current UV position, according to what we sampled
	vec4 color = texture(TEXTURE, UV);

	vec4 outlined_texture = get_outlined_texture(TEXTURE_PIXEL_SIZE, TEXTURE, UV, color);
	COLOR = outlined_texture;
}