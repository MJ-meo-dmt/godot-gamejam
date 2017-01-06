extends Node


const gravity = -9.8
const moveSpeed = 120
const jumpSpeed = 300
var velocity = Vector3()
var canJump = false
var otherBody
var moving = false

var body
var anim

# Player checks on button use
var Game

func _ready():
	body = get_node("PlayerBody")
	anim = get_node("AnimationPlayer")
	set_fixed_process(true)
	set_process(true)
	
	Game = get_tree().get_root().get_node("Game")
	
func _fixed_process(delta):
	velocity.y += gravity * delta
	
	# When moving left or right while trying to jump
	if (Input.is_action_pressed("move-left") and Input.is_action_pressed("move-jump") and canJump):
		velocity.x = -moveSpeed * delta
		velocity.y = jumpSpeed * delta
		canJump = false
	elif (Input.is_action_pressed("move-right") and Input.is_action_pressed("move-jump") and canJump):
		velocity.x = moveSpeed * delta
		velocity.y = jumpSpeed * delta
		canJump = false

	# When only moving left or right without jump and or jumping alone.
	if (Input.is_action_pressed("move-left")):
		body.set_rotation(Vector3(0, -90, 0))
		velocity.x = -moveSpeed * delta
		moving = true
	elif (Input.is_action_pressed("move-right")):
		body.set_rotation(Vector3(0, 90, 0))
		velocity.x = moveSpeed * delta
		moving = true
	elif (Input.is_action_pressed("move-jump") and canJump):
		velocity.y = jumpSpeed * delta
		canJump = false
	else:
		moving = false
	
	var motion = velocity * delta
	body.move(motion)
	
	if(body.is_colliding()):
		canJump = true
		var n = body.get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		body.move(motion)
		velocity.x = 0
		
func _process(delta):
	if(moving):
		if(!anim.is_playing()):
			anim.play("ArmatureAction", -1, 1, false)
	elif(!moving):
		anim.stop(true)
	
	# Check if player is pressing button
	if(Input.is_action_just_pressed("use") and Game.isNearButton == true):
		# Start the timer
		Game.timer()