extends Node

var isNearStartButton
var isNearEndButton
var timerNode

var deathPlane
var player
var spawnPoint

var levelTime = 15.0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	# Deathplane
	deathPlane = get_node("platform_0/DeathPlane")
	deathPlane.connect("body_enter", self, "handleDeath")
	
	# Player
	player = get_node("FinalCharacter_1")
	spawnPoint = get_node("SpawnPoint")
	
	# Timer setting
	isNearStartButton = false
	isNearEndButton = false
	timerNode = Timer.new()
	add_child(timerNode)
	timerNode.connect("timeout", self, "TimeOut")

	# Reset Player
	
	
	# Start processes
	set_fixed_process(true)
	set_process(true)

func handleDeath(body):
	print("Reset player position")
	player.get_node("PlayerBody").set_transform(spawnPoint.get_global_transform())
	

# Gets called via 'e'
func timer():
	timerNode.set_one_shot(true)
	timerNode.set_wait_time(levelTime)
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

func _fixed_process(delta):
	get_node("UI/FPS/Label").set_text("FPS: " + str(OS.get_frames_per_second()))
