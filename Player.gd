extends CharacterBody2D


const SPEED = 300.0

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	if not is_multiplayer_authority(): return
	$Camera2D.make_current()

func _physics_process(_delta):
	if not is_multiplayer_authority(): return
	
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	velocity = direction * SPEED

	move_and_slide()
