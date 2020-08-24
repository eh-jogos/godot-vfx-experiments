tool
extends TextureRect
# Forwards the Y zoom and Y scale values to the mirror shader

### Member Variables and Dependencies -----
# signals 
# enums
# constants
# public variables - order: export > normal var > onready 
# private variables - order: export > normal var > onready 
### ---------------------------------------


### Built in Engine Methods ---------------
func _ready():
	connect("item_rect_changed", self, "_on_item_rect_changed")
	pass


func _process(delta):
	_update_zoom(get_viewport_transform().y.y)
### ---------------------------------------


### Public Methods ------------------------
### ---------------------------------------


### Private Methods -----------------------
func _on_item_rect_changed() -> void:
	var scale_y = rect_size.y / texture.get_size().y
	scale_y *= rect_scale.y
	
	material.set_shader_param("scale_y", scale_y)


func _update_zoom(value: float) -> void:
	material.set_shader_param("zoom_y", value)
### ---------------------------------------


