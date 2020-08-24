extends CPUParticles2D
# Write your doc striing for this file here

### Member Variables and Dependencies -----
# signals 
# enums
# constants
# public variables - order: export > normal var > onready 
# private variables - order: export > normal var > onready
export var _emission_mask: Texture
export(int, 255) var _intensity_threshold: int = 128
export var scale_reference: int = 8
 
### ---------------------------------------


### Built in Engine Methods ---------------
func _ready():
	pass


func _physics_process(delta: float) -> void:
	_process_texture()

### ---------------------------------------


### Public Methods ------------------------
### ---------------------------------------


### Private Methods -----------------------
func _process_texture() -> void:
	var data := _emission_mask.get_data().data
	var width : int = data.width
	var height : int = data.height
	var raw : PoolByteArray = data.data
	
	var positions : = PoolVector2Array()
	
	for x in range(width):
		for y in range(height):
			# This should be  * 4 in GLES3 as it should account for rgba,
			# but in GLES2 is only rgb so it's * 3
			var idx : = (y * width + x) * 3
			
			var byte : int = raw[idx]
			if byte > _intensity_threshold:
				positions.append(Vector2(x, y) * scale_reference)
	
	if positions.size() == 0:
		emitting = false
	else:
		emission_shape = CPUParticles2D.EMISSION_SHAPE_POINTS
		emission_points = positions
		
		emitting = true
### ---------------------------------------


