extends CanvasLayer
# This is a Class to Handle Transitions of any kind. It uses a custom resource called EHJ_TransitionData
# and a tansition shader, to make it very easy to add new kinds of Transition. You can use it 
# as an autoload and call it from anywhere or Add this node to each scene that has a transition.
#
# To use it, create a EHJ_TransitionData with your settings and save it to disk, then drag it to the
# transition_data variable in the editor, or set it by code from somewhere else. 
#
# To preview it, run the scene with F6 and press up to see the transition, and down to see
# the standard fade transition. 
#
# Then whenever you need to call the transition, just call any of the public methods, 
# play_transition_in will only play the first half, play_transition_out will only play the second
# half, and play_transition_full will play it all in sequence. 
#
# If you just want a simple fade in and fade out transition, than you don't need to set any
# custom transition data, and can just use the play_fade_in, play_fade_out and play_fade_transition
# methods.
# 
# Being able to play each half  separately might help to wait a bit if things havent finished
# loading, or it you need to set things up in the scene.
# The signals are also there to help if you need to know of any of these moments.
#
# Lastly, since Godot 3.2.2 doesn't have support for exporting custom resources, I'm using 
# setget and _casted_transition_data to do some workarounds, and ensure that putting any other kind
# of Resource in the transition_data variable won't be accepted and won't break things by mistake, so
# you can ignore it. Just rememeber to create EHJ_TransitionData resources by clicking with the right button
# on the FileSystem panel and choosing "New Resource" and searching for "EHJ_TransitionData" there, to make
# your life easier instead of having to navigate the extensive Resource Menu in the exported var.


### Member Variables and Dependencies -----
# signals 
signal transition_started
signal transition_mid_point_reached
signal transition_finished

# enums
# constants
# public variables - order: export > normal var > onready 
export(Resource) var transition_data : Resource = null setget _set_transition_data, _get_transition_data

# private variables - order: export > normal var > onready 
var _casted_transition_data : EHJ_TransitionData = null

onready var _color_panel: ColorRect = $Transitions
onready var _animator: AnimationPlayer = $Transitions/AnimationPlayer

### ---------------------------------------


### Built in Engine Methods ---------------
func _ready():
	set_process_unhandled_input(false)
	
	if get_tree().current_scene == self:
		print(get_tree().current_scene.name)
		set_process_unhandled_input(true)


func _unhandled_input(event):
	if event.is_action_released("ui_up"):
		play_transition_full()
	elif event.is_action_released("ui_down"):
		play_fade_transition()

### ---------------------------------------


### Public Methods ------------------------
func play_transition_in() -> void:
	_play_in_animation(
			_casted_transition_data.transition_in,
			_casted_transition_data.color,
			_casted_transition_data.duration
	)


func play_transition_out() -> void:
	_play_out_animation(
			_casted_transition_data.transition_out,
			_casted_transition_data.color,
			_casted_transition_data.duration
	)


func play_transition_full() -> void:
	if _animator.is_playing():
		_raise_multiple_transition_error()
		return
	
	play_transition_in()
	
	yield(self, "transition_mid_point_reached")
	
	play_transition_out()


func play_fade_in(color: Color = Color.black, duration: float = 0.5) -> void:
	_play_in_animation("fade_in", color, duration)

func play_fade_out(color: Color = Color.black, duration: float = 0.5) -> void:
	_play_out_animation("fade_out", color, duration)

func play_fade_transition(color: Color = Color.black, duration: float = 0.5) -> void:
	if _animator.is_playing():
		_raise_multiple_transition_error()
		return
	
	play_fade_in(color, duration)
	
	yield(self, "transition_mid_point_reached")
	
	play_fade_out(color, duration)

### ---------------------------------------


### Private Methods -----------------------
func _play_in_animation(animation : String, color: Color, duration: float) -> void:
	if _animator.is_playing():
		_raise_multiple_transition_error()
		return
	
	_color_panel.color = color
	_set_playback_speed(duration)
	
	emit_signal("transition_started")
	
	_animator.play(animation)
	
	yield(_animator, "animation_finished")
	emit_signal("transition_mid_point_reached")


func _play_out_animation(animation : String, color: Color, duration: float) -> void:
	if _animator.is_playing():
		_raise_multiple_transition_error()
		return
	
	_color_panel.color = color
	_set_playback_speed(duration)
	
	_animator.play(animation)
	
	yield(_animator, "animation_finished")
	emit_signal("transition_finished")



func _set_playback_speed(duration: float) -> void:
	_animator.playback_speed = 1.0 / duration


func _set_transition_data(data : EHJ_TransitionData) -> void:
	if data == null:
		return
	
	transition_data = data
	_casted_transition_data = transition_data as EHJ_TransitionData
	
	if not is_inside_tree():
		yield(self, "ready")
	
	_color_panel.color = _casted_transition_data.color
	_set_playback_speed(_casted_transition_data.duration)


func _get_transition_data() -> EHJ_TransitionData:
	if _casted_transition_data != null:
		return _casted_transition_data
	else:
		return null


func _raise_multiple_transition_error() -> void:
	push_error("A new transition is being called while another one is playing")
	# If you're in Debug or this is intended, press F12 or the continue 
	# button in the debugger to continue
	assert(false)

### ---------------------------------------


