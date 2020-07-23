extends MeshInstance
# Write your doc striing for this file here

### Member Variables and Dependencies -----
# signals 
# enums
# constants
# public variables - order: export > normal var > onready 
export var effect_duration: = 0.3

# private variables - order: export > normal var > onready 
onready var _tween: Tween = $Tween
### ---------------------------------------


### Built in Engine Methods ---------------
func _ready():
	_set_outline_thickness(0)
	$StaticBody.connect("mouse_entered", self, "_on_Area2D_mouse_entered")
	$StaticBody.connect("mouse_exited", self, "_on_Area2D_mouse_exited")

### ---------------------------------------


### Public Methods ------------------------
### ---------------------------------------


### Private Methods -----------------------
func _set_outline_thickness(thickness: float) -> void:
	var outline_shader: ShaderMaterial = get_surface_material(0).next_pass as ShaderMaterial
	outline_shader.set_shader_param("thickness", thickness)



func _on_Area2D_mouse_entered():
	var outline_shader: ShaderMaterial = get_surface_material(0).next_pass as ShaderMaterial
	var initial_value = outline_shader.get_shader_param("thickness")
	
	if _tween.is_active():
		_tween.remove_all()
	
	_tween.interpolate_method(self, "_set_outline_thickness", initial_value, 0.1, effect_duration, 
			Tween.TRANS_CUBIC, Tween.EASE_OUT)
	_tween.start()


func _on_Area2D_mouse_exited():
	var outline_shader: ShaderMaterial = get_surface_material(0).next_pass as ShaderMaterial
	var initial_value = outline_shader.get_shader_param("thickness")
	
	if _tween.is_active():
		_tween.remove_all()
	
	_tween.interpolate_method(self, "_set_outline_thickness", initial_value, 0, effect_duration, 
			Tween.TRANS_CUBIC, Tween.EASE_IN)
	_tween.start()

### ---------------------------------------
