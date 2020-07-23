shader_type canvas_item;

uniform vec2 blur_scale = vec2(1, 0);

void fragment(){
	const float SAMPLES = 17.0; 
	const float WEIGHTS[16] = {
		0.01473,
		0.022898,
		0.033562,
		0.046382,
		0.060438,
		0.074255,
		0.086019,
		0.093953,
		0.096758,
		0.093953,
		0.086019,
		0.074255,
		0.060438,
		0.046382,
		0.033562,
		0.022898
	};
	
	vec2 scale = TEXTURE_PIXEL_SIZE * blur_scale;
	
	float weight = 0.0;
	float total_weight = 0.0;
	vec4 color = vec4(0.0);
	
	for (int i=-int(SAMPLES)/2; i < int(SAMPLES)/2; ++i) {
		int weight_index = i + int(SAMPLES)/2;
		weight = WEIGHTS[w];
		vec2 sample_offset = scale * vec2(float(i));
		color += texture(TEXTURE, UV + sample_offset ) * weight;
		total_weight += weight;
	}
	
	vec4 blurred_color = color / total_weight;
	
	COLOR = blurred_color;
}