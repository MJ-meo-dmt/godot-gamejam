extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var area

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	area = get_node("Area")
	area.connect("body_enter", self, "body_enter")

func body_enter(body):
	print(body.get_name())
