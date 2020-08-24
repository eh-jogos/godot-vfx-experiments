extends Sprite

export var _blur_effect_path : = NodePath()
onready var blur_effect_shader: ShaderMaterial = get_node(_blur_effect_path).material

func _ready():
	pass
	


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var mouse_event: InputEventMouseMotion = event as InputEventMouseMotion
		position = mouse_event.position
		var relative_position = position / get_viewport_rect().size
		blur_effect_shader.set_shader_param("position", relative_position)
