extends Camera2D
"
const:
	- SPEED (float):
		移動的速度。
	- ZOOM_POWER (float):
		縮放的力度。
"


const SPEED := 100.0
const ZOOM_POWER := 1.2


func _physics_process(delta):
	# position
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	position = position.move_toward(position + direction, SPEED * delta)
	
	# zoom
	if Input.is_action_just_pressed("zoom_in"):
		zoom *= ZOOM_POWER
	if Input.is_action_just_pressed("zoom_out"):
		zoom /= ZOOM_POWER
