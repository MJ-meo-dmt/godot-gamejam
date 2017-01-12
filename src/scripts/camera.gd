extends Camera

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var player

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var root = get_tree().get_root()
	player = root.get_node("Game/FinalCharacter_1/PlayerBody")
	set_process(true)

func _process(delta):
	var target = player.get_translation()
	set_translation(target + Vector3(-5.87195, 0.839886, 7.640726))
	