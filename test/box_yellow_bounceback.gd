extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var can_hit = true

func _physics_process(delta):
#	if not is_on_floor():
	velocity.y -= gravity * delta

	move_and_slide()

func pushback(position):
	velocity = (global_transform.origin - position).normalized()*4
	velocity.y = 5
	can_hit = false
	await get_tree().create_timer(1). timeout
	can_hit = true
	velocity = Vector3.ZERO
