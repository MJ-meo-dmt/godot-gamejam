extends Node

var isNearButton
var timerNode

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	isNearButton = false
	timerNode = Timer.new()
	add_child(timerNode)
	timerNode.connect("timeout", self, "TimeOut")
	
	set_process(true)

# Gets called via 'e'
func timer():
	timerNode.set_one_shot(true)
	timerNode.set_wait_time(5)
	timerNode.start()
	
func TimeOut():
	print ("timer done")
	timerNode.stop()

func _process(delta):
	get_node("UI/TimerPanel/Label").set_text("Time Remaining: " + str(timerNode.get_time_left()))


	
