extends Node3D

@onready var anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func Shoot():
	if anim.is_playing():
		pass
	else:
		anim.play("kick")
	
