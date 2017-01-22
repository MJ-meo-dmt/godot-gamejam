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
	area.connect("body_exit", self, "body_exit")

func body_enter(body):
	if(body.get_name() == "PlayerBody"):
		print(body.get_name())
		get_tree().get_root().get_node("Game/UI/InfoUI/Panel").show()
		get_tree().get_root().get_node("Game/UI/InfoUI/Panel/Label").set_text("Press 'e' to start timer")
		get_tree().get_root().get_node("Game").isNearStartButton = true

func body_exit(body):
	get_tree().get_root().get_node("Game/UI/InfoUI/Panel").hide()
	get_tree().get_root().get_node("Game").isNearStartButton = false
