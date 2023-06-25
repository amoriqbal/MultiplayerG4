extends CharacterBody2D


const SPEED = 300.0

var ability = abilities.MELEE
enum abilities {MELEE, RANGE, SHIELD}

@export
var health:int = 100

@rpc("any_peer")
func damage(amount):
#	if not is_multiplayer_authority(): return
	if health > amount:
		health -= amount
	else:
		health = 0
	print("health: " + str(health))
	print("id: " + str(multiplayer.get_unique_id()))
#	var newMaterial = CanvasItemMaterial.new() #Make a new Spatial Material
#	newMaterial.albedo_color = Color(0.92, 0.69, 0.13, 1.0) #Set color of new material
#	$MeshInstance2D.material_override = newMaterial #Assign new material to material overrride


func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	if not is_multiplayer_authority(): return
	$Camera2D.make_current()

func _physics_process(_delta):
	$MeshInstance2D.modulate = Color(health, 0, 0)
	if not is_multiplayer_authority(): return
	
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	velocity = direction * SPEED

	move_and_slide()
	
	if Input.is_key_pressed(KEY_SPACE):
		use_ability(ability)
		

func use_ability(ability):
	if not is_multiplayer_authority(): return
		
	if ability == abilities.MELEE:
		use_melee()
	elif ability == abilities.RANGE:
		use_range()
	
func use_melee():
	if not is_multiplayer_authority(): return
	var overlaps =  $MeleeRange.get_overlapping_areas()
	for area in overlaps:
		if area != self.get_node("Body"):
#			var attacked_player_id = get_node("res://main.tscn").get_peer_id(area.get_node("Player"))
#			var attacked_player_id = area.get_tree().get_multiplayer().get_unique_id()
			var attacked_player_id = area.get_multiplayer_authority()
			rpc_id(attacked_player_id, "damage", 1)
#	overlaps.erase()
#	if overlaps.size() > 0:
#		print(overlaps.size())
#		print(overlaps)
	
func use_range():
	if not is_multiplayer_authority(): return
	

		
