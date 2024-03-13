class_name BlockLike2DManager
extends Node2D
## 用於管理子節點中的BlockLike2D物件。
"
exports:
	- block_selected_flash_speed (float):
		BlockLike2D物件被選擇時的閃爍速度,預設為1.0。
	- cell_size (Vector2):
		BlockLike2D物件的格子大小，預設為Vector2(16,16)。
	- mouse_entered_modulate_alpha (float):
		滑鼠進入BlockLike2D物件時其透明度應調整的值，只能設置在0.0到1.0之間，預設為0.8。
"


@export var block_selected_flash_speed := 1.0
@export var cell_size := Vector2(16, 16)
@export_range(0.0, 1.0) var mouse_entered_modulate_alpha := 0.8
