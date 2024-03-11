"
任何一個
"
class_name BlockLike2D
extends Node2D

const BLOCK_SIZE = 16
const MODULATE_ALPHA_UPDATE_SPEED = 1.0

var block_area: Area2D

var _is_able_to_be_placed := true:
	set(value):
		_is_able_to_be_placed = value
		if not _is_able_to_be_placed:
			return
		for overlapping_area in block_area.get_overlapping_areas():
			if overlapping_area.is_in_group("BLOCK_AREA"):
				_is_able_to_be_placed = false
				break
var _is_picked_up := false:
	set(value):
		if not _is_selected:
			value = false
		if _is_picked_up == value:
			return
		_is_picked_up = value
		if _is_picked_up:
			_picked_up_global_mouse_pos = get_global_mouse_position()
			z_index += 100
		else:
			position = _previous_position
			z_index -= 100
var _is_selected := false:
	set(value):
		if not _is_able_to_be_placed:
			return
		_is_selected = value
		if _is_selected:
			return
		_previous_position = position
		_is_picked_up = false
var _is_mouse_entered := false
var _picked_up_global_mouse_pos: Vector2
var _previous_position: Vector2

func _ready():
	# block_area
	var rect = RectangleShape2D.new()
	rect.size = Vector2(BLOCK_SIZE - 0.1, BLOCK_SIZE - 0.1)
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = rect
	block_area = Area2D.new()
	block_area.add_child(collision_shape)
	block_area.add_to_group("BLOCK_AREA")
	block_area.area_entered.connect(_on_block_area_area_entered)
	block_area.area_exited.connect(_on_block_area_area_exited)
	block_area.mouse_entered.connect(_on_block_area_mouse_entered)
	block_area.mouse_exited.connect(_on_block_area_mouse_exited)
	add_child(block_area)
	
	# position
	_locate()
	_previous_position = position

func _physics_process(delta):
	if Input.is_action_just_released("mouse_left"):
		if _is_mouse_entered:
			_is_selected = not _is_selected
		elif not Input.is_key_pressed(KEY_CTRL):
			_is_selected = false
	if Input.is_action_just_released("mouse_right"):
		_is_picked_up = not _is_picked_up

	_update_modulate()
	if _is_picked_up:
		position = _previous_position + get_global_mouse_position() - _picked_up_global_mouse_pos
		_locate()

func select():
	pass

func _locate():
	position = Vector2i((position + position.sign() * BLOCK_SIZE / 2) / 16) * 16

func _on_block_area_area_entered(area: Area2D):
	_is_able_to_be_placed = false
	
func _on_block_area_area_exited(area: Area2D):
	_is_able_to_be_placed = true

func _on_block_area_mouse_entered():
	_is_mouse_entered = true
	
func _on_block_area_mouse_exited():
	_is_mouse_entered = false

func _update_modulate():
	modulate.a = 1.0
	modulate.r = 1.0
	modulate.g = 1.0
	modulate.b = 1.0
	if not _is_selected:
		return
	modulate.a = abs(int(Time.get_ticks_msec() * 20 * MODULATE_ALPHA_UPDATE_SPEED / 1000) % 20 - 10) / 10.0
	if not _is_picked_up:
		return
	if _is_able_to_be_placed:
		# green
		modulate.r = 0.0
		modulate.b = 0.0
	else:
		# red
		modulate.g = 0.0
		modulate.b = 0.0
