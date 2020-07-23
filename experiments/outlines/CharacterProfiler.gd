extends Sprite
# Write your doc striing for this file here

### Member Variables and Dependencies -----
# signals 
# enums
# constants
# public variables - order: export > normal var > onready 
export var info_panel_path: = NodePath()

# private variables - order: export > normal var > onready 
onready var _outline_shader: ShaderMaterial = material as ShaderMaterial
onready var _info_panel: Sprite = get_node(info_panel_path) as Sprite
### ---------------------------------------


### Built in Engine Methods ---------------
func _ready():
	$Area2D.connect("mouse_entered", self, "_on_Area2D_mouse_entered")
	$Area2D.connect("mouse_exited", self, "_on_Area2D_mouse_exited")
	
	_info_panel.hide()

### ---------------------------------------


### Public Methods ------------------------
### ---------------------------------------


### Private Methods -----------------------
func _on_Area2D_mouse_entered():
	var color = _outline_shader.get_shader_param("line_color")
	color.a = 1
	_outline_shader.set_shader_param("line_color", color)
	_outline_shader.set_shader_param("line_thickness", 5.0)
	_info_panel.show()


func _on_Area2D_mouse_exited():
	var color = _outline_shader.get_shader_param("line_color")
	color.a = 0
	_outline_shader.set_shader_param("line_color", color)
	_outline_shader.set_shader_param("line_thickness", 0)
	_info_panel.hide()

### ---------------------------------------
