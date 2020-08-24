shader_type canvas_item;

const float SAMPLES = 25.0;
const float PI2 = 6.28319;

uniform vec2 blur_scale = vec2(1, 0);

float gaussian(float x) {
	float x_squared = x*x;
	float width = 1.0 / sqrt(PI2 * SAMPLES);
	
	return width * exp((x_squared / (2.0 * SAMPLES)) * -1.0);
}

void fragment(){
	vec2 scale = TEXTURE_PIXEL_SIZE * blur_scale;
	
	float weight = 0.0;
	float total_weight = 0.0;
	vec4 color = vec4(0.0);
	
	for (int i=-int(SAMPLES)/2; i < int(SAMPLES)/2; ++i) {
		weight = gaussian(float(i));
		vec2 sample_offset = scale * vec2(float(i));
		color += texture(TEXTURE, UV + sample_offset ) * weight;
		total_weight += weight;
	}
	
	vec4 blurred_color = color / total_weight;
	
	COLOR = blurred_color;
}