extends Node2D

enum { OBSTACLE, COLLECTABLE, RESOURCE }

var tile_size: int = 16
var grid_size: Vector2i = Vector2i(160, 160)
var grid: Array = []

var tree: PackedScene = preload("res://World Objects/tree.tscn")
var house: PackedScene = preload("res://Houses/coin_house.tscn")


func _ready():
	init_empty_grid()
	init_trees()
	


func init_empty_grid() -> void:
	for x: int in range(grid_size.x):
		grid.append([])
		for y: int in range(grid_size.y):
			grid[x].append(null)


func init_trees() -> void:
	var positions: Array = []
	for i: int in range(50):
		var x_coor: int = randi() % int(grid_size.x)
		var y_coor: int = randi() % int(grid_size.y)
		var grid_position: Vector2i = Vector2i(x_coor, y_coor)
		if not grid_position in positions:
			positions.append(grid_position)
	
	for pos: Vector2i in positions:
		var tree_instance: StaticBody2D = tree.instantiate()
		tree_instance.set_position(tile_size * pos)
		grid[pos.x][pos.y] = OBSTACLE
		add_child(tree_instance)
		
	var mini_map_node: SubViewport = get_tree().get_root().get_node("World/UI/MiniMap/SubViewportContainer/SubViewport")
	mini_map_node.update_trees()


func _input(event) -> void:
	if event.is_action_pressed("LeftClick"):
		var mouse_position: Vector2 = get_global_mouse_position()
		var multi_x: int = int(round(mouse_position.x) / tile_size)
		var multi_y: int = int(round(mouse_position.y) / tile_size)
		var new_pos: Vector2i = Vector2i(multi_x, multi_y)
		
		var around: bool = false
		
		for i: int in range(tile_size):
			if grid[multi_x + i][multi_y] != null or grid[multi_x - i][multi_y] != null or grid[multi_x][multi_y + i] != null or grid[multi_x][multi_y - i] != null:
				around = true
				break
		
		if grid[multi_x][multi_y] == null:
			if around == false:
				var house_instance: StaticBody2D = house.instantiate()
				house_instance.set_position(tile_size * new_pos)
				grid[multi_x][multi_y] = OBSTACLE
				$"../Resources".add_child(house_instance)
				var mini_map_node: SubViewport = get_tree().get_root().get_node("World/UI/MiniMap/SubViewportContainer/SubViewport")
				mini_map_node.update_resources()
