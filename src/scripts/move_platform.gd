extends Area

var area
var doRotate = false

func _ready():
	connect("body_enter", self, "body_enter")
	connect("body_exit", self, "body_exit")

func body_enter(body):
	if(body.get_name() == "PlayerBody"):
		doRotate = true
		set_process(true)
		

func body_exit(body):
	if(body.get_name() == "PlayerBody"):
		doRotate = false
		set_process(false)
		
func _process(delta):
	if(doRotate == true):
		set_rotation(get_rotation() + Vector3(0, 0, -0.8 * delta))