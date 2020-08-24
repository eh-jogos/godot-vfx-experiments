shader_type canvas_item;

uniform vec2 position = vec2(0.5);
uniform float radius :hint_range(0.0,1.5) = 0.3;
uniform float edge_hardness :hint_range (0.0,1.0) = 0.5;
uniform vec2 circle_resolution = vec2(1.0);

void fragment()
{
	float distance_to_circle_center = length((UV - position) * circle_resolution);
	float mask = smoothstep(radius*edge_hardness, radius, distance_to_circle_center);
	vec4 texture_color = texture(TEXTURE, UV);
	COLOR = texture_color;
	COLOR.a = mask;
}