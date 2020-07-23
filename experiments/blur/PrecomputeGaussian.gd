tool
extends EditorScript
# Write your doc striing for this file here

### Member Variables and Dependencies -----
# signals 
# enums
# constants
const SAMPLES = 17
# public variables - order: export > normal var > onready 
# private variables - order: export > normal var > onready 
### ---------------------------------------


### Built in Engine Methods ---------------
func _run() -> void:
	var output: = "const float SAMPLES = %s.0; \n" % [SAMPLES]
	output += "\t const float WEIGHTS[%s] = {" % [SAMPLES if SAMPLES % 2 == 0 else SAMPLES -1]
	
	for i in range(-SAMPLES/2.0, SAMPLES/2.0):
		output += "\n\t\t%s," % gaussian(float(i))
	
	output = output.rstrip(",") + "\n\t};"
	
	OS.clipboard = output
	print("Precomputing gaussian weights: \n%s" % [output])

### ---------------------------------------


### Public Methods ------------------------
func gaussian(x: float) -> float:
	var x_squared := x*x;
	var width := 1.0 / sqrt(PI*2*SAMPLES)
	
	return width * exp((x_squared / (2.0 * SAMPLES)) * -1.0)

### ---------------------------------------


### Private Methods -----------------------
### ---------------------------------------


