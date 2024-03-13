extends BlockLike2D


enum Type {
	FROM_LEFT_TO_RIGHT,
	FROM_LEFT_TO_DOWN,
	FROM_LEFT_TO_UP,
	FROM_UP_TO_DOWN,
	FROM_UP_TO_LEFT,
	FROM_UP_TO_RIGHT,
	FROM_RIGHT_TO_LEFT,
	FROM_RIGHT_TO_UP,
	FROM_RIGHT_TO_DOWN,
	FROM_DOWN_TO_UP,
	FROM_DOWN_TO_RIGHT,
	FROM_DOWN_TO_LEFT,
}


const UPDATE_SPEED = 1.0


@export var type := Type.FROM_LEFT_TO_RIGHT


@onready var image: Sprite2D = $Image


func _ready():
	super._ready()
	
	# type
	rotation = deg_to_rad(type / 3 * 90)
	image.frame_coords.y = type % 3


func _process(delta):
	_animate(delta)


func _animate(delta):
	image.frame_coords.x = int(Time.get_ticks_msec() / 1000.0 * UPDATE_SPEED * image.hframes) % image.hframes
