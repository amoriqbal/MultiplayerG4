extends CharacterBody2D

const SPEED = 300.0
var FortArea: Area2D = null

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

func _input(event):
	if not is_multiplayer_authority(): return
	if event.is_action_pressed("fortify") and FortArea != null:
		var castleBlock = FortArea.getCastleBlock()
		if castleBlock.occupant == "":
			var castleBlockPosition = FortArea.global_position
			global_position = castleBlockPosition
			castleBlock.rpc_id(1, "setOccupant", name)
			

func _on_area_2d_area_entered(area):
	if area.name == "FortArea":
		print_debug(area.get_parent().name)
		FortArea = area


func _on_area_2d_area_exited(area):
	if area.name == "FortArea":
		FortArea = null
