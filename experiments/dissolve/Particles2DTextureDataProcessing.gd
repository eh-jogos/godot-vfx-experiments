extends Particles2D
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
			var byte : int = raw[idx]
			if byte > 128:
				positions.append(Vector2(x, y)  - position)
	
	if positions.size() == 0:
		emitting = false
	else:
		var buffer : = StreamPeerBuffer.new()
		for pos in positions:
			buffer.put_float(pos.x)
			buffer.put_float(pos.y)
		
		var new_width : = 2048
		var new_height : = (positions.size() / 2048) + 1
		var output : = buffer.data_array
		output.resize(new_width * new_height * 8)
		
		var image : = Image.new()
		image.create_from_data(new_width, new_height, false, Image.FORMAT_RGF, output)
		
		var image_texture : = ImageTexture.new()
		image_texture.create_from_image(image)
		
		process_material.emission_shape = ParticlesMaterial.EMISSION_SHAPE_POINTS
		process_material.emission_point_texture = image_texture
		process_material.emission_point_count = positions.size()
		
		emitting = true
### ---------------------------------------


