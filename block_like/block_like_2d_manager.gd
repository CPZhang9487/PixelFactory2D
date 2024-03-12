class_name BlockLike2DManager
extends Node2D
## 用於管理子節點中的BlockLike2D物件。
"
exports:
	- block_selected_flash_speed (float):
		BlockLike2D物件被選擇時的閃爍速度，預設為1.0。
	- cell_size (Vector2):
		格子的基礎大小，預設為Vector2(16,16)。
"


@export var block_selected_flash_speed := 1.0
@export var cell_size := Vector2(16, 16)
