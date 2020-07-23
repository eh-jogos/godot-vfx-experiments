extends StaticBody
# Write your doc striing for this file here

### Member Variables and Dependencies -----
# signals 
# enums
# constants
# public variables - order: export > normal var > onready 
export var effect_duration: = 1.5

# private variables - order: export > normal var > onready 
onready var _dissolve_shader: ShaderMaterial = $MeshInstance.get_surface_material(0) as ShaderMaterial
onready var _tween: Tween = $Tween
### ---------------------------------------


### Built in Engine Methods ---------------
func _ready():
	_set_dissolve_amount(0)
	connect("mouse_entered", self, "_on_Area2D_mouse_entered")
	connect("mouse_exited", self, "_on_Area2D_mouse_exited")

### ---------------------------------------


### Public Methods ------------------------
### ---------------------------------------


### Private Methods -----------------------
func _set_dissolve_amount(percent: float) -> void:
	_dissolve_shader.set_shader_param("dissolve_amount", percent)



func _on_Area2D_mouse_entered():
	var initial_value = _dissolve_shader.get_shader_param("dissolve_amount")
	
	if _tween.is_active():
		_tween.remove_all()
	
	_tween.interpolate_method(self, "_set_dissolve_amount", initial_value, 1.0, effect_duration, 
			Tween.TRANS_LINEAR, Tween.EASE_IN)
	_tween.start()


func _on_Area2D_mouse_exited():
	var initial_value = _dissolve_shader.get_shader_param("dissolve_amount")
	
	if _tween.is_active():
		_tween.remove_all()
	
	_tween.interpolate_method(self, "_set_dissolve_amount", initial_value, 0, effect_duration, 
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	_tween.start()

### ---------------------------------------
