extends Node
class_name eh_SceneChanger
# Scene Changer custom node to be used as a helper in conjuction with eh_Transitions
#
# Just instance this node in your scene, and set the path to the next scene in the
# exported variable in the editor. Then either call `transition_to_next_scene()` from
# code, or just instance it as a child of a button and it will connect itself to the 
# `pressed` signal.
# 
# You can also optionally set a transition data to override the default one that is 
# set in eh_Transition.tscn just for this transition.

### Member Variables and Dependencies -----
# signals 
# enums
# constants
# public variables - order: export > normal var > onready 
# private variables - order: export > normal var > onready
export(String, FILE, "*.tscn") var _next_scene_path: String = ""
export(Resource) var transition_data = null

### ---------------------------------------


### Built in Engine Methods ---------------
func _ready():
	var parent = get_parent()
	yield(parent, "ready")
	if parent is BaseButton:
		parent.connect("pressed", self, "_on_owner_pressed")

### ---------------------------------------


### Public Methods ------------------------
func transition_to_next_scene() -> void:
	if transition_data != null and transition_data is eh_TransitionData:
		eh_Transitions.change_transition_data_oneshot(transition_data)
	
	eh_Transitions.play_transition_in()
	yield(eh_Transitions, "transition_mid_point_reached")
	get_tree().change_scene(_next_scene_path)
	eh_Transitions.play_transition_out()

### ---------------------------------------


### Private Methods -----------------------
func _on_owner_pressed() -> void:
	transition_to_next_scene()

### ---------------------------------------


