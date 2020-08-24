tool
extends Node
class_name RemoteVisibility
# Write your doc striing for this file here

### Member Variables and Dependencies -----
# signals 
# enums
# constants
# public variables - order: export > normal var > onready 
# private variables - order: export > normal var > onready 
export var _remote_path : = NodePath()

var _parent: CanvasItem

onready var _remote_node : CanvasItem = get_node(_remote_path) as CanvasItem
### ---------------------------------------


### Built in Engine Methods ---------------
func _ready():
	var parent_node = get_parent()
	yield(parent_node, "ready")
	if parent_node is CanvasItem:
		_parent = parent_node as CanvasItem
		_parent.connect("visibility_changed", self, "_on_parent_visibility_changed")
	pass

### ---------------------------------------


### Public Methods ------------------------

### ---------------------------------------


### Private Methods -----------------------
func _on_parent_visibility_changed() -> void:
	_remote_node.visible = _parent.visible
### ---------------------------------------


