extends PathFollow2D

@export
var pathFollowSpeed : float = 0.01

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	progress_ratio += delta * pathFollowSpeed
