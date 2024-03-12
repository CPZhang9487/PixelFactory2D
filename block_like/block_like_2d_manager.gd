class_name BlockLike2DManager
extends Node2D
## 用於管理子節點中的BlockLike2D物件。
"
exports:
	- block_selected_flash_speed (float):
		BlockLike2D物件被選擇時的閃爍速度，預設為1.0。
	- cell_size (Vector2):
		格子的基礎大小，預設為Vector2(16, 16)。
"


@export var block_selected_flash_speed := 1.0
@export var cell_size := Vector2(16, 16)


func _physics_process(delta: float):
	for block_like_2d: BlockLike2D in get_children():
		if Input.is_action_just_released("mouse_left"):
			if block_like_2d.is_picked_up:
				block_like_2d.be_putted_down()
			elif not block_like_2d.is_mouse_entered:
				block_like_2d.be_unselected()
			elif not block_like_2d.is_selected:
				block_like_2d.be_selected()
			else:
				block_like_2d.be_unselected()
	
		if Input.is_action_just_released("mouse_right"):
			if block_like_2d.is_picked_up:
				block_like_2d.be_unpicked_up()
			else:
				block_like_2d.be_picked_up()
	
		if block_like_2d.is_picked_up:
			block_like_2d.position = block_like_2d.picked_up_position + get_global_mouse_position() - block_like_2d.picked_up_global_mouse_pos
		
		block_like_2d.locate()
		block_like_2d.update_modulate()
