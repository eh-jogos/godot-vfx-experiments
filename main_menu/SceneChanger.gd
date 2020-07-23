extends Node
class_name SceneChanger
# Write your doc striing for this file here

### Member Variables and Dependencies -----
# signals 
# enums
# constants
# public variables - order: export > normal var > onready 
# private variables - order: export > normal var > onready
export(String, FILE, "*.tscn") var _next_scene_path: String = ""

### ---------------------------------------


### Built in Engine Methods ---------------
func _ready():
	var parent = get_parent()
	yield(parent, "ready")
	if parent is BaseButton:
		parent.connect("pressed", self, "_on_owner_pressed")

### ---------------------------------------


### Public Methods ------------------------
### ---------------------------------------


### Private Methods -----------------------
func _on_owner_pressed() -> void:
	get_tree().change_scene(_next_scene_path)

### ---------------------------------------


