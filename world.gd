extends Node2D

var units: Array = []


func _ready():
	get_units()


func get_units() -> void:
	units = get_tree().get_nodes_in_group("units")


func _on_area_selected(object):
	var start = object.start
	var end = object.end
	var area: Array = []
	area.append(Vector2(min(start.x, end.x), min(start.y, end.y)))
	area.append(Vector2(max(start.x, end.x), max(start.y, end.y)))
	var units_selected: Array = get_units_in_area(area)
	
	deselect_all_units()
		
	for unit in units_selected:
		unit.set_selected(!unit.selected)


func deselect_all_units():
	for unit in units:
		unit.set_selected(false)


func get_units_in_area(area: Array):
	var _units: Array = []
	for unit in units:
		if (unit.position.x > area[0].x) and (unit.position.x < area[1].x):
			if (unit.position.y > area[0].y) and (unit.position.y < area[1].y):
				_units.append(unit)
	
	return _units
