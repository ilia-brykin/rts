extends SubViewport

var camera_world_node: Camera2D
var houses_world_node: Node2D
var units_world_node: Node2D
var objects_world_node: Node2D
var resources_world_node: Node2D

var barrack_sprite: PackedScene = preload("res://UI/MiniMap Sprites/barrack_sprite.tscn")
var tree_sprite: PackedScene = preload("res://UI/MiniMap Sprites/tree_sprite.tscn")
var arthax_sprite: PackedScene = preload("res://UI/MiniMap Sprites/arthax_sprite.tscn")
var coin_house_sprite: PackedScene = preload("res://UI/MiniMap Sprites/coin_house_sprite.tscn")

@onready var camera: Camera2D = $Camera


func _ready():
	get_world_scenes()
	update_map()


func _process(_delta):
	update_camera()
	update_units_position()


func get_world_scenes():
	var root_world_window: Window = get_tree().get_root()
	camera_world_node = root_world_window.get_node("World/Camera")
	
	houses_world_node = root_world_window.get_node("World/Houses")
	units_world_node = root_world_window.get_node("World/Units")
	objects_world_node = root_world_window.get_node("World/Objects")
	resources_world_node = root_world_window.get_node("World/Resources")


func update_camera():
	camera.position = camera_world_node.position / 2
	camera.zoom = camera_world_node.zoom / 2


func update_map():
	build_objects(houses_world_node, barrack_sprite, $Houses)
	build_objects(resources_world_node, coin_house_sprite, $Resources)
	build_objects(objects_world_node, tree_sprite, $Objects)
	update_units()


func update_trees():
	$TreeTimer.start()


func update_units():
	clear_group_node($Units)
	build_objects(units_world_node, arthax_sprite, $Units)


func clear_group_node(group_node: Node2D):
	for i: int in group_node.get_child_count():
		group_node.get_child(i).queue_free()


func build_objects(world_node: Node2D, sprite: PackedScene, group_node: Node2D):
	for i: int in world_node.get_child_count():
		var sprite_instance: Sprite2D = sprite.instantiate()
		sprite_instance.position = world_node.get_child(i).position / 2
		group_node.add_child(sprite_instance)


func update_units_position():
	var units_count_local = $Units.get_child_count()
	for i: int in units_world_node.get_child_count():
		if i > units_count_local - 1:
			break
		$Units.get_child(i).position = units_world_node.get_child(i).position / 2


func _on_tree_timer_timeout():
	clear_group_node($Objects)
	build_objects(objects_world_node, tree_sprite, $Objects)
