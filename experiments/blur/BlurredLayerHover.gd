extends LayerHoverDetector
# Write your doc striing for this file here

### Member Variables and Dependencies -----
# signals 
# enums
# constants
# public variables - order: export > normal var > onready 
# private variables - order: export > normal var > onready 
onready var _crossfader = $CrossFader 

### ---------------------------------------


### Built in Engine Methods ---------------
func _ready():
	_detection_layers = get_tree().get_nodes_in_group("blur_detection")


### ---------------------------------------


### Public Methods ------------------------
### ---------------------------------------


### Private Methods -----------------------
func _set_activated(value: bool) -> void:
	._set_activated(value)
	_crossfader.set_blur(is_activated)
### ---------------------------------------


