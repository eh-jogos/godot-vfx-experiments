shader_type canvas_item;

uniform sampler2D alternate_viewport;
uniform sampler2D mask_viewport;
uniform vec4 dim_main_view : hint_color;

void fragment(){
	vec4 main_color = texture(TEXTURE, UV);
	vec4 alternate_color = texture(alternate_viewport, UV);
	float mask_value = texture(mask_viewport, UV).r;
	float mask_inverse = 1.0 - mask_value;
	
	vec4 out_color = main_color * mask_inverse;
	vec4 alt_color = alternate_color * mask_value;
	vec4 dimmed_color = dim_main_view * mask_inverse;
	COLOR = clamp(out_color * dimmed_color + alt_color, 0, 1);
}
