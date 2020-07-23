shader_type canvas_item;

uniform float torus_thickness : hint_range(0.001, 1.0) = 0.5;
uniform float torus_hardness = 1.0;
uniform float torus_radius = 1.0;
uniform float torus_invert : hint_range(-1.0, 1.0) = -1.0;
uniform vec2 torus_center = vec2(0.5, 0.5);
uniform vec2 torus_resolution = vec2(1.0, 1.0);

uniform float displacement_amount;

void fragment(){
	float torus_distance = length((UV - torus_center) * torus_resolution);
	float radius_difference = torus_thickness / 2.0;
	float inner_radius = torus_radius - radius_difference;
	
	float distance_to_inner_torus_edge = abs(torus_distance - inner_radius);
	float percent_distance_from_thickness = distance_to_inner_torus_edge / torus_thickness;
	float circle_value = clamp(percent_distance_from_thickness, 0.0, 1.0);
	
	float circle_alpha = pow(circle_value, pow(torus_hardness, 2.0));
	
	// This is here so that I don't need to do an if to determine the mask direction
	float torus_invert_value = clamp(abs(sign(torus_invert)) - sign(torus_invert), 0.0, 1.0);
	float mask = abs(torus_invert_value - circle_alpha) * abs(torus_invert);
	
	vec2 displaced_uv = UV + mask * displacement_amount;
	
	vec4 distored_color = texture(TEXTURE, displaced_uv);
	
	COLOR = distored_color;
}