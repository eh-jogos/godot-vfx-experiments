shader_type canvas_item;

uniform vec4 silhouette_color : hint_color = vec4(0);

void fragment(){
	vec4 sample = texture(TEXTURE, UV);
	COLOR.rgb = silhouette_color.rgb;
	COLOR.a = sample.a;
}