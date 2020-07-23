extends Area2D
class_name LayerHoverDetector
# Write your doc striing for this file here

### Member Variables and Dependencies -----
# signals 
# enums
# constants
# public variables - order: export > normal var > onready 
var is_activated: = false setget _set_activated

# private variables - order: export > normal var > onready
var _detection_layers: Array = []

### ---------------------------------------


### Built in Engine Methods ---------------
func _ready():
	connect("mouse_exited", self, "_on_mouse_exited")
	connect("input_event", self, "_on_input_event")



### ---------------------------------------


### Public Methods ------------------------
### ---------------------------------------


### Private Methods -----------------------
func _on_mouse_exited() -> void:
	self.is_activated = false


func _on_input_event(_viewport, _event, _shape_idx):
	self.is_activated = _should_activate()


func _should_activate() -> bool:
	var should_activate : = true
	
	for layer in _detection_layers:
		var area_layer: Area2D = layer as Area2D if layer is Area2D else null
		if area_layer == null:
			continue
		
		if area_layer.priority > priority and area_layer.is_activated:
			should_activate = false
		
	return should_activate


func _set_activated(value: bool) -> void:
	is_activated = value

### ---------------------------------------
