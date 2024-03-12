class_name BlockLike2D
extends Node2D
"
exports:
	- block_size (Vector2):
		自身的大小，預設為Vector2(1, 1)。

public attributes:
	- block_area (Area2D):
		覆蓋自身範圍的Area2d物件。
		在'BLOCK_AREA'群組中。
	- block_selected_flash_speed (float):
		被選擇時的閃爍速度。
		若父節點為BlockLike2DManager，則會根據父節點的block_selected_flash_speed進行動態調整。
	- cell_size (Vector2):
		格子大小。
		若父節點為BlockLike2DManager，則會根據父節點的cell_size進行動態調整。
	- is_able_to_be_placed (bool):
		是否能夠被放置。
	- is_mouse_entered (bool):
		是否滑鼠進入自身範圍內。
	- is_picked_up (bool):
		是否被撿起。
	- is_selected (bool):
		是否被選擇。
	- picked_up_global_mouse_pos (Vector2):
		被撿起時的全域滑鼠位置。
	- picked_up_position: (Vector2):
		被撿起時的自身位置。

public functions:
	- be_picked_up():
		直接看函數本身比較快。
	- be_putted_down():
		直接看函數本身比較快。
	- be_selected():
		直接看函數本身比較快。
	- be_unpicked_up():
		直接看函數本身比較快。
	- be_unselected():
		直接看函數本身比較快。
	- locate(cell_size: Vector2) -> void:
		依照cell_size定位自身的position。
		詳細說明在函數本身中。
	- update_modulate(block_selected_flash_speed: float) -> void:
		更新自身的modulate，若會閃爍則閃爍速度依照block_selected_flash_speed決定。
		詳細說明在函數本身中。

protected functions:
	- _on_block_area_area_entered(area: Area2D) -> void:
		透過自身信號area_entered(area: Area2D)觸發。
		當area為其他的block_area，自身的is_able_to_be_placed=false。
	- _on_block_area_area_exited(area: Area2D) -> void:
		透過自身信號area_exited(area: Area2D)觸發。
		若自身的block_area沒有與任何其他的block_area重疊，自身的is_able_to_be_placed=true。
	- _on_block_area_mouse_entered() -> void:
		透過自身信號mouse_entered()觸發。
		自身的is_mouse_entered=true。
	- _on_block_area_mouse_exited() -> void:
		透過自身信號mouse_exited()觸發。
		自身的is_mouse_entered=false。
"
enum Shape {
	NULL,
	ONE,
	TWO,
	THREE,
	FOUR,
}


@export var block_size := Vector2(1, 1)
@export var block_shape: Array[Shape] = [Shape.ONE]

var block_area := Area2D.new()
var block_selected_flash_speed := 1.0
var cell_size := Vector2(16, 16)
var is_able_to_be_placed := true
var is_mouse_entered := false
var is_picked_up := false
var is_selected := false
var picked_up_global_mouse_pos: Vector2
var picked_up_position: Vector2


func _ready():
	# block_area
	var rect = RectangleShape2D.new()
	rect.size = block_size * cell_size - Vector2(0.001, 0.001)
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = rect
	block_area.add_child(collision_shape)
	block_area.add_to_group("BLOCK_AREA")
	block_area.area_entered.connect(_on_block_area_area_entered)
	block_area.area_exited.connect(_on_block_area_area_exited)
	block_area.mouse_entered.connect(_on_block_area_mouse_entered)
	block_area.mouse_exited.connect(_on_block_area_mouse_exited)
	add_child(block_area)


func be_picked_up():
	if is_picked_up:
		return
	if not is_selected:
		return
	
	is_picked_up = true
	picked_up_global_mouse_pos = get_global_mouse_position()
	picked_up_position = position


func be_putted_down():
	if not is_able_to_be_placed:
		return
	if not is_picked_up:
		return
	if not is_selected:
		return
	
	is_picked_up = false
	is_selected = false


func be_selected():
	if is_selected:
		return
	
	is_selected = true


func be_unpicked_up():
	if not is_picked_up:
		return
	
	is_picked_up = false
	position = picked_up_position


func be_unselected():
	if is_picked_up:
		return
	if not is_selected:
		return
	
	is_selected = false


func locate() -> void:
	"
	這邊以x做解說，y同理。
	透過x-=block_size.x*cell_size.x/2將x定位到自身範圍的左側。
	再透過x=int((x+sign(x)*cell_size.x/2)/cell_size.x)計算x在格子中的座標。
	例如cell_size=16時，x在-24到-8之間的計算結果為-1，在-8到8之間為0，在8到24之間為1。
	隨後x*=cell_size.x獲得全域位置。
	最後透過x+=block_size.x*cell_size.x/2將x定位到自身範圍的中心。
	"
	
	# 這邊_position使用:=賦值是為了將類型定為Vector2
	var _position := position
	_position -= block_size * cell_size / 2
	# 因為_position類型應為Vector2，使用Vector2i賦值後會將Vector2i轉為Vector2
	_position = Vector2i((_position + _position.sign() * cell_size / 2) / cell_size)
	# _position類型之所以要定為Vector2正是因為Vector2i無法跟Vector2做*運算
	_position *= cell_size
	_position += block_size * cell_size / 2
	position = _position


func update_modulate() -> void:
	"
	1. modulate預設為白色。
	2. 當not is_selected時return。
	3. 透過modulate的alpha隨著遊戲時間改變做出閃爍的效果。
	4. 當not is_picked_up時return。
	5. 透過is_able_to_be_placed調整modulate為綠色或紅色。
	"
	
	"1."
	modulate = Color.WHITE
	
	"2."
	if not is_selected:
		return
	
	"3."
	modulate.a = abs(int(Time.get_ticks_msec() * 20 * block_selected_flash_speed / 1000) % 20 - 10) / 10.0
	
	"4."
	if not is_picked_up:
		return
	
	"5."
	if is_able_to_be_placed:
		# green
		modulate.r = 0.0
		modulate.b = 0.0
	else:
		# red
		modulate.g = 0.0
		modulate.b = 0.0


func _on_block_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("BLOCK_AREA"):
		is_able_to_be_placed = false


func _on_block_area_area_exited(area: Area2D) -> void:
	for overlapping_area in block_area.get_overlapping_areas():
		if overlapping_area.is_in_group("BLOCK_AREA"):
			return
	is_able_to_be_placed = true


func _on_block_area_mouse_entered() -> void:
	is_mouse_entered = true


func _on_block_area_mouse_exited() -> void:
	is_mouse_entered = false
