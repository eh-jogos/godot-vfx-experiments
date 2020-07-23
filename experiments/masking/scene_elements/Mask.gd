tool
extends Node2D
# Write your doc striing for this file here

### Member Variables and Dependencies -----
# signals 
# enums
# constants
# public variables - order: export > normal var > onready 
# private variables - order: export > normal var > onready 
### ---------------------------------------


### Built in Engine Methods ---------------
func _draw() -> void:
	draw_polygon(
			[Vector2.ZERO, Vector2(700,150), Vector2(700,-150)],
			[Color.white]
	)

### ---------------------------------------


### Public Methods ------------------------
### ---------------------------------------


### Private Methods -----------------------
### ---------------------------------------


