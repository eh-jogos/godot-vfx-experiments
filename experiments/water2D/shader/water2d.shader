shader_type canvas_item;

const vec3 VIEW_DIRECTION = vec3(0,-0.707,0.707);

uniform vec4 shore_color :hint_color = vec4(1.0);
// Size of the shore in V coordinates
uniform float shore_size :hint_range(0.0,0.2) = 0.01;
uniform float shore_smoothness :hint_range(0.0,0.1) = 0.02;
uniform float shore_height_factor :hint_range(0.01,0.1) = 0.1;

uniform vec2 water_direction = vec2(1.0, 0.0);
uniform float water_time_scale :hint_range(0.01, 2.0) = 0.1;
uniform vec4 water_tint :hint_color = vec4(1.0);
uniform vec4 shadow_color :hint_color;

uniform float scale_y_factor :hint_range(0.1, 4.0) = 2.0;
uniform float tile_factor :hint_range(0.1,3.0) = 1.4;

uniform sampler2D distortion_map :hint_black;

uniform vec2 distortion_scale = vec2(0.5,0.5);
uniform float distortion_time_scale :hint_range(0.01, 0.15) = 0.05;
uniform float distortion_amplitude :hint_range(0.005,0.4) = 0.1;

uniform mat3 transform = mat3(vec3(1,0,0), vec3(0,1,0),vec3(0,0,1));
uniform float parallax_factor :hint_range(0.0,1.0) = 0.2;

uniform sampler2D transition_gradient :hint_black;
uniform float reflection_intensity :hint_range(0.01, 1.0) = 0.5;

// Updated from GDScript
uniform vec2 scale;
uniform float zoom_y;
uniform float aspect_ratio;

vec2 calculate_distorition(vec2 uv, float time){
	vec2 base_uv_offset = uv * distortion_scale + time * distortion_time_scale;
	vec2 distortion_map_sample = texture(distortion_map, base_uv_offset).rg;
	
	// This will give us a range of [-1.0, 1.0]
	vec2 offset_distortion_uv_range = distortion_map_sample * 2.0 - 1.0;
	return offset_distortion_uv_range * distortion_amplitude;
}

vec4 get_water_color(sampler2D water_texture, vec2 uv, float time, vec2 distortion, 
		inout float height, inout vec2 parallax_offset)
{
	vec2 uv_waves = uv * scale * tile_factor;
	uv_waves.y *= aspect_ratio * scale_y_factor;
	uv_waves += water_direction * time * water_time_scale;
	uv_waves += distortion;
	
	// magic number to scale the texture up and use a different time scale to reuse the same
	// distortion map instead of having a separate height map
	height = texture(distortion_map, uv_waves * 0.05 + time * 0.004).r;
	parallax_offset = VIEW_DIRECTION.xy / VIEW_DIRECTION.z * height * parallax_factor+0.3;
	
	uv_waves -= parallax_offset;
	
	return texture(water_texture, uv_waves) * water_tint;
}

float get_reflected_y(float uv_size_ratio_v, float current_uv_y){
	return uv_size_ratio_v * current_uv_y * 2.0 * scale.y * zoom_y;
}

vec4 get_reflected_color(vec2 texture_size, vec2 screen_size, vec2 uv, vec2 screen_uv, 
		sampler2D screen_texture, vec2 distortion, vec2 parallax_offset)
{
	vec2 uv_size_ratio = texture_size / screen_size;
	vec2 uv_reflected = vec2(screen_uv.x, screen_uv.y + get_reflected_y(uv_size_ratio.y, uv.y));
	uv_reflected += uv_size_ratio * distortion;
	uv_reflected -= parallax_offset * vec2(0.0, uv_size_ratio.y);
	return texture(screen_texture, uv_reflected);
}

void fragment(){
	vec3 projection = vec3(UV, 1.0) * transform;
	vec2 uv = projection.xy / projection.z;
	
	vec2 distortion = calculate_distorition(uv, TIME);
	
	float height;
	vec2 parallax_offset;
	vec4 color_water = get_water_color(TEXTURE, uv, TIME, distortion, height, parallax_offset);
	color_water.rgb = mix(color_water.rgb, color_water.rgb * shadow_color.rgb, parallax_factor - height);
	
	vec4 color_reflected = get_reflected_color(1.0 / TEXTURE_PIXEL_SIZE, 1.0 / SCREEN_PIXEL_SIZE, 
			uv, SCREEN_UV, SCREEN_TEXTURE, distortion, parallax_offset);
	
	float transition = texture(transition_gradient, vec2(uv.y, 1.0)).r;
	vec4 color_water_reflected = mix(color_water, color_reflected, transition * reflection_intensity);
	
	COLOR = color_water_reflected;
	
	float waves_height_gradient = UV.y - ((1.0 - height) * shore_height_factor);
	float upper_part = 1.0 - step(0.0, waves_height_gradient);
	float shoreline = smoothstep(0.0, waves_height_gradient, shore_size);
	float wave_area = smoothstep(waves_height_gradient, 0.0, shore_smoothness * (1.0 - UV.y));
	wave_area -= upper_part;
	
	COLOR.rgb += shoreline * shore_color.rgb;
	COLOR.r = min(COLOR.r, 1.0);
	COLOR.g = min(COLOR.g, 1.0);
	COLOR.b = min(COLOR.b, 1.0);
	COLOR.a *= wave_area;
	
}