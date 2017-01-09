extends Node

var isNearStartButton
var isNearEndButton
var timerNode

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	isNearStartButton = false
	isNearEndButton = false
	timerNode = Timer.new()
	add_child(timerNode)
	timerNode.connect("timeout", self, "TimeOut")
	
	set_process(true)

# Gets called via 'e'
func timer():
	timerNode.set_one_shot(true)
	timerNode.set_wait_time(8)
	timerNode.start()
	set_process(true)

func stopTimer():
	set_process(false)
	timerNode.stop()
	
func TimeOut():
	print ("timer done")
	timerNode.stop()

func _process(delta):
	if(timerNode.is_active()):
		get_node("UI/TimerPanel/Label").set_text("Time Remaining: " + str(timerNode.get_time_left()))
