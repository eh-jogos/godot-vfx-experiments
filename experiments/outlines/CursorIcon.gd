extends Sprite


func _ready():
	pass
	


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var mouse_event: InputEventMouseMotion = event as InputEventMouseMotion
		position = mouse_event.position
