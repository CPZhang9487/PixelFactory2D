extends BlockLike2D

const UPDATE_SPEED = 3.0

@onready var image: Sprite2D = $Image

func _process(delta):
	_animate()

func _animate():
	image.frame_coords.x = int(Time.get_ticks_msec() * BLOCK_SIZE * UPDATE_SPEED / 1000) % image.hframes
