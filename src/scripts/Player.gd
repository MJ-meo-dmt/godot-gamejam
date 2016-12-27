extends Node


const gravity = -9.8
const moveSpeed = 120
const jumpSpeed = 300
var velocity = Vector3()
var canJump = false

var body

func _ready():
	body = get_node("KinematicBody")
	set_fixed_process(true)
	
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
		velocity.x = -moveSpeed * delta
	elif (Input.is_action_pressed("move-right")):
		velocity.x = moveSpeed * delta
	elif (Input.is_action_pressed("move-jump") and canJump):
		velocity.y = jumpSpeed * delta
		canJump = false
	else:
		velocity.x = 0
	
	var motion = velocity * delta
	body.move(motion)
	
	if(body.is_colliding()):
		canJump = true
		var n = body.get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		body.move(motion)
