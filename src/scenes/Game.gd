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

var isMenuOpen = false

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
	
	# Connect the redo button
	get_node("UI/EndGamePanel/RedoLevelBtn").connect("button_down", self, "doRedo")
	# Connect StartGameButton
	get_node("UI/Menu/PlayGameBtn").connect("button_down", self, "startGame")
	# Connect ExitButton
	get_node("UI/Menu/ExitBtn").connect("button_down", self, "exitGame")
	# Connect High score btn
	get_node("UI/Menu/HighScoreBtn").connect("button_down", self, "ShowHighScore")
	
func startGame():
	# Start processes
	set_fixed_process(true)
	set_process(true)
	player.startGame()
	get_node("UI/Menu").hide()
	get_node("UI/InfoUI").show()

func exitGame():
	get_tree().quit()

func ShowHighScore():
	get_node("UI/Menu/Info").hide()

func handleDeath(body=false):
	print("Reset player position")
	stopTimer()
	get_node("UI/InfoUI/TimerPanel/Label").set_text("Time Remaining: " + "0.0")
	get_tree().set_pause(false)
	player.get_node("PlayerBody").set_transform(spawnPoint.get_global_transform())
	player.totalJumps = 0
	get_node("platform_0/EndPlatform").set_rotation( Vector3(0, 0, 0))
	get_node("Potion").show()
	
	# Reset Endgamepanel
	get_node("UI/EndGamePanel").hide()
	get_node("UI/InfoUI").show()
	player.startGame()
	
#Gets called via 'e'
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
	get_node("UI/InfoUI/Boons/Panel/Label").set_text("Chip Time: ")
	timerNode.set_active(true)
	st = null

func stopTimer():
	set_process(false)
	var timeLeft = timerNode.get_time_left()
	timerNode.stop()
	# Game end button has been pressed Hide rest of UI and display endgamepanel
	var endGamePanel = get_node("UI/EndGamePanel")
	get_node("UI/InfoUI").hide()
	player.stopGame()
	endGamePanel.show()
	endGamePanel.get_node("TimeLeft/value").set_text(str(timeLeft))
	endGamePanel.get_node("TotalJumps/value").set_text(str(player.totalJumps))
	endGamePanel.get_node("Points/value").set_text(str(timeLeft / player.totalJumps * 100))
	
func TimeOut():
	print ("timer done")
	timerNode.stop()
	
func doRedo():
	handleDeath()

func _process(delta):
	if(timerNode.is_active()):
		get_node("UI/InfoUI/TimerPanel/Label").set_text("Time Remaining: " + str(timerNode.get_time_left()))
		get_node("UI/InfoUI/Boons/JumpsCounter/Value").set_text("Jumps: "+str(player.totalJumps))
	else:
		if(st != null):
			get_node("UI/InfoUI/Boons/Panel/Label").set_text("Chip Time: " + str(st.get_time_left()))
	
	if(Input.is_action_just_pressed("open_menu")):
		if(isMenuOpen):
			doPauseHideMenu()
		else:
			doPauseShowMenu()

func _fixed_process(delta):
	get_node("UI/DebugUI/FPS/Label").set_text("FPS: " + str(OS.get_frames_per_second()))


# Simple menu methods
func doPauseShowMenu():
	#get_node("UI/InfoUI").hide()
	get_node("UI/Menu").show()
	timerNode.set_pause_mode(true)
	player.stopGame()
	isMenuOpen = true
	
func doPauseHideMenu():
	get_node("UI/Menu").hide()
	timerNode.set_pause_mode(false)
	player.startGame()
	isMenuOpen = false
