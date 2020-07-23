extends Node
# Write your doc striing for this file here

### Member Variables and Dependencies -----
# signals 
# enums
# constants
# public variables - order: export > normal var > onready 
# private variables - order: export > normal var > onready
export var from_path: = NodePath()
export var target_path: = NodePath()

onready var _from = get_node(from_path)
onready var _target = get_node(target_path)
onready var _tween: Tween = $Tween
 
### ---------------------------------------


### Built in Engine Methods ---------------
func _ready():
	_from.modulate.a = 1
	_from.show()
	
	_target.modulate.a = 0
	_target.show()

### ---------------------------------------


### Public Methods ------------------------
func set_blur(should_activate: bool) -> void:
	if should_activate:
		crossfade_to_target()
	else:
		crossfade_from_target()

### ---------------------------------------


### Private Methods -----------------------
func crossfade_to_target(duration := 0.3) -> void:
	_tween.interpolate_property(_from, "modulate:a", _from.modulate.a, 0, duration, 
			Tween.TRANS_CUBIC, Tween.EASE_IN)
	_tween.interpolate_property(_target, "modulate:a", _target.modulate.a, 1, duration, 
			Tween.TRANS_CUBIC, Tween.EASE_OUT)
	_tween.start()


func crossfade_from_target(duration := 0.3) -> void:
	_tween.interpolate_property(_from, "modulate:a", _from.modulate.a, 1, duration, 
			Tween.TRANS_CUBIC, Tween.EASE_OUT)
	_tween.interpolate_property(_target, "modulate:a", _target.modulate.a, 0, duration, 
			Tween.TRANS_CUBIC, Tween.EASE_IN)
	_tween.start()

### ---------------------------------------


