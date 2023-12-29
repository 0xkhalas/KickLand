extends CharacterBody3D

@onready var head = $Head
@onready var raycast = $Head/Camera3D/RayCast3D
@onready var cam = $Head/Camera3D
@onready var Gun = $Head/Camera3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.1

var knockback = Vector3.ZERO
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var lerp_speed = 10.0
var direction = Vector3.ZERO;

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cam.current = is_multiplayer_authority()

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
		head.rotate_x(-deg_to_rad(event.relative.y * SENSITIVITY))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(delta):
	if ! is_multiplayer_authority(): return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Use Gun
	if Input.is_action_just_pressed("Shoot"):
		$Head/Camera3D/Gun.Shoot()
		if raycast.is_colliding():
			var target = raycast.get_collider()
			var hit_position = raycast.get_collision_point()
			if target != null:
				print(target.is_in_group("box"))
				if target.is_in_group("box") && target.has_method("pushback"):
					target.pushback(global_transform.origin)
	
	if Input.is_action_just_pressed("quit"):
		$"../".exit_game(name.to_int())
		get_tree().quit() 
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta*lerp_speed)
	
	# Add Movement
	velocity.x = direction.x * SPEED;
	velocity.z = direction.z * SPEED;
	
	# Add Knockback
	velocity += knockback

	move_and_slide()

func pushback(hit_position):
	velocity = (global_transform.origin - hit_position).normalized()*4
	velocity.y = 5
	
