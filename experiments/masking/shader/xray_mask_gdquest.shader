shader_type canvas_item;

uniform sampler2D alternate_viewport;
uniform sampler2D mask_viewport;
uniform float dim_main_view : hint_range(0,1) = 0.2;

void fragment(){
	vec4 main_color = texture(TEXTURE, UV);
	vec4 alternate_color = texture(alternate_viewport, UV);

	float mask_value = texture(mask_viewport, UV).r;
	float mask_inverse = 1.0 - mask_value;
	
	vec4 out_color = main_color * (1.0 - alternate_color * mask_value);
	out_color += alternate_color * mask_value;
	vec4 dimmed_color = vec4(vec3(dim_main_view),0.0) * mask_inverse;
	COLOR = clamp(out_color - dimmed_color, 0, 1);
}
