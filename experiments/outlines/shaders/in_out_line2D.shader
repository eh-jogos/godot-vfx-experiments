shader_type canvas_item;

uniform vec4 line_color: hint_color = vec4(1.0); // White
uniform float line_thikness: hint_range(0.0, 20.0) = 1.0;

void fragment(){
	vec2 line_size_in_units = TEXTURE_PIXEL_SIZE * line_thikness / 2.0;
	
	// We are sampling around the current UV position in all 8 directions
	float sample_left = texture(TEXTURE, UV + vec2(-line_size_in_units.x, 0)).a;
	float sample_left_top = texture(TEXTURE, UV + vec2(-line_size_in_units.x, line_size_in_units.y)).a;
	float sample_top = texture(TEXTURE, UV + vec2(0, line_size_in_units.y)).a;
	float sample_top_right = texture(TEXTURE, UV + vec2(line_size_in_units.x, line_size_in_units.y)).a;
	float sample_right = texture(TEXTURE, UV + vec2(line_size_in_units.x, 0)).a;
	float sample_right_down = texture(TEXTURE, UV + vec2(line_size_in_units.x, -line_size_in_units.y)).a;
	float sample_down = texture(TEXTURE, UV + vec2(0, -line_size_in_units.y)).a;
	float sample_down_left = texture(TEXTURE, UV + vec2(-line_size_in_units.x, -line_size_in_units.y)).a;
	
	vec4 color = texture(TEXTURE, UV);
	
	float sample_sum = sample_down + sample_down_left + sample_left + sample_left_top 
			+ sample_right + sample_right_down + sample_top + sample_top_right;
	float sample_product = sample_down * sample_down_left * sample_left * sample_left_top 
			* sample_right * sample_right_down * sample_top * sample_top_right;
	
	float outline_alpha = min(sample_sum, 1.0);
	float inline_alpha = 1.0 - sample_product;
	
	
	float outline_mask = outline_alpha - color.a;
	float inline_mask = inline_alpha * color.a;
	vec4 stroke_result= mix(color, line_color, outline_mask + inline_mask);
	
	COLOR = mix(color, stroke_result, stroke_result.a);
	
}