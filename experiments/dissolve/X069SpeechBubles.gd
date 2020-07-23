extends Polygon2D
# Write your doc striing for this file here

### Member Variables and Dependencies -----
# signals 
# enums
# constants
const complain_speeches = [ 
	"OH NO!",
	"NOT AGAIN",
	"HAVE MERCY",
]

const relieved_speeches = [
	"THANKS",
	"PHEW!",
	"NOT TODAY!",
]

# public variables - order: export > normal var > onready 
# private variables - order: export > normal var > onready 
var _complaints: = 0

onready var _label: Label = $Label
onready var _tween: Tween = $Tween

### ---------------------------------------


### Built in Engine Methods ---------------
func _ready():
	randomize()
	_label.text = ""

### ---------------------------------------


### Public Methods ------------------------
func complain() -> void:
	_label.percent_visible = 0
	
	var index: int = 0
	if _complaints < complain_speeches.size():
		index = _complaints
	else:
		index = randi() % complain_speeches.size()
	
	_label.text = complain_speeches[index]
	_complaints += 1
	
	_tween.interpolate_property(_label, "percent_visible", _label.percent_visible, 1.0, 0.3, 
			Tween.TRANS_LINEAR, Tween.EASE_IN)
	_tween.start()


func feel_relieved() -> void:
	_label.percent_visible = 0
	
	var index: = randi() % relieved_speeches.size()
	_label.text = relieved_speeches[index]
	
	_tween.interpolate_property(_label, "percent_visible", _label.percent_visible, 1.0, 0.5, 
			Tween.TRANS_LINEAR, Tween.EASE_IN)
	_tween.start()

### ---------------------------------------


### Private Methods -----------------------
### ---------------------------------------


