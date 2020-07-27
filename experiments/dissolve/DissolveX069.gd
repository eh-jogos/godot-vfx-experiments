extends Sprite
# Write your doc striing for this file here

### Member Variables and Dependencies -----
# signals 
# enums
# constants
# public variables - order: export > normal var > onready 
export var effect_duration: = 1.5

# private variables - order: export > normal var > onready 
export var _texture_mask_shader_nodepath : = NodePath()

onready var _mask_dissolve_shader: ShaderMaterial = \
		get_node(_texture_mask_shader_nodepath).material as ShaderMaterial

onready var _dissolve_shader: ShaderMaterial = material as ShaderMaterial
onready var _balloon: Polygon2D = $Balloon
onready var _tween: Tween = $Tween
### ---------------------------------------


### Built in Engine Methods ---------------
func _ready():
	$Area2D.connect("mouse_entered", self, "_on_Area2D_mouse_entered")
	$Area2D.connect("mouse_exited", self, "_on_Area2D_mouse_exited")
	
	_set_dissolve_amount(0)
	_balloon.modulate.a = 0

### ---------------------------------------


### Public Methods ------------------------

### ---------------------------------------


### Private Methods -----------------------
func _set_dissolve_amount(percent: float) -> void:
	_dissolve_shader.set_shader_param("dissolve_amount", percent)
	_mask_dissolve_shader.set_shader_param("dissolve_amount", percent)


func _on_Area2D_mouse_entered():
	var current_dissolve = _dissolve_shader.get_shader_param("dissolve_amount")
	
	if _tween.is_active():
		_tween.remove_all()
	
	_balloon.complain()
	
	_tween.interpolate_property(_balloon, "modulate:a", _balloon.modulate.a, 1.0, 0.3, 
			Tween.TRANS_LINEAR, Tween.EASE_IN)
	_tween.interpolate_method(self, "_set_dissolve_amount", current_dissolve, 1.0, effect_duration, 
			Tween.TRANS_LINEAR, Tween.EASE_IN)
	_tween.interpolate_property(_balloon, "modulate:a", 1.0, 0, 0.3, Tween.TRANS_LINEAR, 
			Tween.EASE_IN, effect_duration - 0.3)
	_tween.start()


func _on_Area2D_mouse_exited():
	var current_dissolve = _dissolve_shader.get_shader_param("dissolve_amount")
	
	if _tween.is_active():
		_tween.remove_all()
	
	_balloon.feel_relieved()
	
	if _balloon.modulate.a != 0.0:
		_tween.interpolate_property(_balloon, "modulate:a", _balloon.modulate.a, 1.0, 0.3, Tween.TRANS_LINEAR, 
			Tween.EASE_IN)
	
	_tween.interpolate_method(self, "_set_dissolve_amount", current_dissolve, 0.0, effect_duration, 
			Tween.TRANS_LINEAR, Tween.EASE_IN)
	_tween.interpolate_property(_balloon, "modulate:a", _balloon.modulate.a, 0, 0.3, Tween.TRANS_LINEAR, 
			Tween.EASE_IN, effect_duration - 0.3)
	_tween.start()

### ---------------------------------------
