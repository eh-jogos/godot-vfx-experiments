extends Resource
class_name eh_TransitionData
# Custom Resource (similar to ScriptableObjects in Unity) created to handle transitions
#
# color: the color that will fill the screen during the transition, alpha will be ignored
# duration: how long each half of the transition will take. Ex: a duration of 0.5 will take 0.5 
#           seconds to fill the screen with a color (transition_in) and another 0.5 seconds to 
#           fade out that color.
# mask: Expects a grayscale image, that wil be used by the shader to animate the transition. 
# transition_in: The kind of in transition you want to use
#                - transition_in: will fill the screen from black to white according to the mask
#                - reversed_in: will fill the screen from white to black according to the mask
# transition_out: The kind of in transition you want to use
#                - transition_out: will fade the screen from black to white according to the mask
#                - reversed_out: will fade the screen from white to black according to the mask
#
# There are some basic masks in the masks folder, but you can use any mask you want as long as it's
# a grayscale gradient in some form or another.
#
# Also there are already some basic transitions created in the examples folder.
#
# For simple fade in and fade out you don't need to create a eh_TransitionData resource, you can
# just use the public methods in the EHJ_Transitions scene.

### Member Variables and Dependencies -----
# signals 
# enums
# constants
# public variables - order: export > normal var > onready 
export var color: Color = Color.black
export var duration: float = 0.0 setget _set_duration, _get_duration
export var mask: Texture = null
export(String, "transition_in", "reversed_in") \
		var transition_in: = "transition_in"
export(String, "transition_out", "reversed_out") \
		var transition_out: = "transition_out"

# private variables - order: export > normal var > onready 
### ---------------------------------------


### Built in Engine Methods ---------------
### ---------------------------------------


### Public Methods ------------------------
### ---------------------------------------


### Private Methods -----------------------
func _set_duration(value: float) -> void:
	duration = max(0, value)

func _get_duration() -> float:
	return duration

### ---------------------------------------
