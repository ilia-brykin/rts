extends Node2D

var house_position: Vector2 = Vector2(300, 300)

@onready var unit: PackedScene = preload("res://unit/unit.tscn")


func _on_yes_pressed():
	var units_node: Node2D = get_tree().get_root().get_node("World/Units")
	var world_node: Node2D = get_tree().get_root().get_node("World")
	var unit_instance: CharacterBody2D = unit.instantiate()
	unit_instance.position = house_position + get_random_position()
	units_node.add_child(unit_instance)
	world_node.get_units()
	var mini_map_node: SubViewport = get_tree().get_root().get_node("World/UI/MiniMap/SubViewportContainer/SubViewport")
	mini_map_node.update_units()


func get_random_position() -> Vector2:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	var random_pos_x: int = rng.randi_range(-50, 50)
	var random_pos_y: int = rng.randi_range(-50, 50)
	
	return Vector2(random_pos_x, random_pos_y)


func _on_no_pressed():
	var houses_node: Node2D = get_tree().get_root().get_node("World/Houses")
	for i: int in houses_node.get_child_count():
		if houses_node.get_child(i).selected == true:
			houses_node.get_child(i).selected = false
	Game.close_spawn_unit()
	queue_free()
