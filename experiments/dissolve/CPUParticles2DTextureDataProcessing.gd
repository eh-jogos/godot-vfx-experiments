extends CPUParticles2D
# Write your doc striing for this file here

### Member Variables and Dependencies -----
# signals 
# enums
# constants
# public variables - order: export > normal var > onready 
# private variables - order: export > normal var > onready
export var _emission_mask: Texture
 
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
			var idx : = (y * width + x) * 4
			
#			idx = clamp(idx, 0, raw.size()-1)
			
			var byte : int = raw[idx]
			if byte > 128:
				positions.append(Vector2(x, y) * 8)
	
	if positions.size() == 0:
		emitting = false
	else:
		emission_shape = CPUParticles2D.EMISSION_SHAPE_POINTS
		emission_points = positions
		
		emitting = true
### ---------------------------------------


