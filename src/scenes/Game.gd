extends Node

var isNearStartButton
var isNearEndButton
var timerNode

var deathPlane
var player
var spawnPoint

var slowtimerScene
var slowtimerNode

var levelTime = 20.0
var slowBoon = 4.0
var st

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

	# Boons
	slowtimerScene = load("res://scenes/Potion.tscn")
	st = null
	
	# Start processes
	set_fixed_process(true)
	set_process(true)

func handleDeath(body):
	print("Reset player position")
	player.get_node("PlayerBody").set_transform(spawnPoint.get_global_transform())
	get_node("platform_0/EndPlatform").set_rotation( Vector3(0, 0, 0))
	get_node("Potion").show()
	
	# Reset Chips
	#slowtimerNode = slowtimerScene.instance()
	#print (slowtimerNode)
	

# Gets called via 'e'
func timer():
	timerNode.set_one_shot(true)
	timerNode.set_wait_time(levelTime)
	timerNode.start()
	set_process(true)

func slowtimer():
	timerNode.set_active(false)
	st = Timer.new()
	add_child(st)
	st.connect("timeout", self, "slowtimer_timeout")
	st.set_one_shot(true)
	st.set_wait_time(slowBoon)
	st.start()

func slowtimer_timeout():
	get_node("UI/Boons/Panel/Label").set_text("Chip Time: ")
	timerNode.set_active(true)
	st = null

func stopTimer():
	set_process(false)
	timerNode.stop()
	
func TimeOut():
	print ("timer done")
	timerNode.stop()

func _process(delta):
	if(timerNode.is_active()):
		get_node("UI/TimerPanel/Label").set_text("Time Remaining: " + str(timerNode.get_time_left()))
	
	else:
		if(st != null):
			get_node("UI/Boons/Panel/Label").set_text("Chip Time: " + str(st.get_time_left()))

func _fixed_process(delta):
	get_node("UI/FPS/Label").set_text("FPS: " + str(OS.get_frames_per_second()))
