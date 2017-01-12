extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var Game

var area

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	Game = get_tree().get_root().get_node("Game")
	area = get_node("Area")
	area.connect("body_enter", self, "body_enter")
	
func body_enter(body):
	if(body.get_name() == "PlayerBody"):
		print("Player hit with potion")
		print("Slowing time! for 30 sec")
		

