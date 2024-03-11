class_name BlockLike2DManager
extends Node2D
## 用於管理子節點中的BlockLike2D物件。


## BlockLike2D物件的基礎大小。
@export var block_size := Vector2(16, 16)
## BlockLike2D物件被選擇時的閃爍速度
@export var modulate_alpha_update_speed := 1.0


func _physics_process(delta: float):
	for block_like_2d in get_children():
		if Input.is_action_just_released("mouse_left"):
			if block_like_2d.is_mouse_entered:
				block_like_2d.is_selected = not block_like_2d.is_selected
			elif not Input.is_key_pressed(KEY_CTRL):
				block_like_2d.is_selected = false

		if Input.is_action_just_released("mouse_right"):
			block_like_2d.is_picked_up = not block_like_2d.is_picked_up
		if block_like_2d.is_picked_up:
			block_like_2d.position = block_like_2d.previous_position + get_global_mouse_position() - block_like_2d.picked_up_global_mouse_pos
		
		locate(block_like_2d)
		update_modulate(block_like_2d)


## 將BlockLike2D物件加到子節點中。
func add(block_like_2d: BlockLike2D):
	add_child(block_like_2d)


## 定位BlockLike2D物件到正確的地方，常駐在_physics_process(delta)中呼叫。
func locate(block_like_2d: BlockLike2D):
	var _position = block_like_2d.position
	var _block_size = block_like_2d.scale * block_size
	_position.x = int((_position.x + sign(_position.x) * _block_size.x / 2) / _block_size.x) * _block_size.x
	_position.y = int((_position.y + sign(_position.y) * _block_size.y / 2) / _block_size.y) * _block_size.y
	block_like_2d.position = _position


## 更新BlockLike2D物件的modulate，常駐在_physics_process(delta)中呼叫。
func update_modulate(block_like_2d: BlockLike2D):
	var _is_able_to_be_placed = block_like_2d.is_able_to_be_placed
	var _is_picked_up = block_like_2d.is_picked_up
	var _is_selected = block_like_2d.is_selected
	var _modulate = block_like_2d.modulate
	
	_modulate.a = 1.0
	_modulate.r = 1.0
	_modulate.g = 1.0
	_modulate.b = 1.0
	block_like_2d.modulate = _modulate
	
	if not _is_selected:
		return
	
	_modulate.a = abs(int(Time.get_ticks_msec() * 20 * modulate_alpha_update_speed / 1000) % 20 - 10) / 10.0
	block_like_2d.modulate = _modulate
	
	if not _is_picked_up:
		return
	
	if _is_able_to_be_placed:
		# green
		_modulate.r = 0.0
		_modulate.b = 0.0
	else:
		# red
		_modulate.g = 0.0
		_modulate.b = 0.0
	block_like_2d.modulate = _modulate


## 移除子節點中的BlockLike2D物件。
func remove(block_like_2d: BlockLike2D):
	remove_child(block_like_2d)
