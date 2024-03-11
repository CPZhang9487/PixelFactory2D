"
任何一個
"
class_name BlockLike2D
extends Node2D

const BLOCK_SIZE = 16

var block_area: Area2D

var is_able_to_be_placed := true:
	set(value):
		is_able_to_be_placed = value
		if not is_able_to_be_placed:
			return
		for overlapping_area in block_area.get_overlapping_areas():
			if overlapping_area.is_in_group("BLOCK_AREA"):
				is_able_to_be_placed = false
				break
var is_picked_up := false:
	set(value):
		if not is_selected:
			value = false
		if is_picked_up == value:
			return
		is_picked_up = value
		if is_picked_up:
			picked_up_global_mouse_pos = get_global_mouse_position()
			z_index += 100
		else:
			position = previous_position
			z_index -= 100
var is_selected := false:
	set(value):
		if not is_able_to_be_placed:
			return
		is_selected = value
		if is_selected:
			return
		previous_position = position
		is_picked_up = false
var is_mouse_entered := false
var picked_up_global_mouse_pos: Vector2
var previous_position: Vector2

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
	previous_position = position


func _on_block_area_area_entered(area: Area2D):
	is_able_to_be_placed = false


func _on_block_area_area_exited(area: Area2D):
	is_able_to_be_placed = true


func _on_block_area_mouse_entered():
	is_mouse_entered = true


func _on_block_area_mouse_exited():
	is_mouse_entered = false
