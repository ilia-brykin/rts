extends Camera2D

var mousePos: Vector2 = Vector2()

var mousePosGlobal: Vector2 = Vector2()
var start: Vector2 = Vector2()
var startV: Vector2 = Vector2()
var end: Vector2 = Vector2()
var endV: Vector2 = Vector2()
var isDragging: bool = false

signal area_selected
signal atart_move_selection


func _process(_delta):
	if Input.is_action_just_pressed("LeftClick"):
		start = mousePosGlobal
		startV = mousePos
		isDragging = true
		
	if isDragging:
		end = mousePosGlobal
		endV = mousePos
		draw_area()
		
	if Input.is_action_just_released("LeftClick"):
		if startV.distance_to(mousePos) > 20:
			end = mousePosGlobal
			endV = mousePos
			isDragging = false
			draw_area(false)
			emit_signal("area_selected")
		else:
			end = start
			isDragging = false
			draw_area(false)


func _input(event):
	if event is InputEventMouse:
		mousePos = event.position
		mousePosGlobal = get_global_mouse_position()


func draw_area(s: bool = true):
	get_node("../Panel").size = Vector2(abs(startV.x - endV.x), abs(startV.y - endV.y))
	var pos = Vector2()
	pos.x = min(startV.x, endV.x)
	pos.y = min(startV.y, endV.y)
	get_node("../Panel").position = pos
	get_node("../Panel").size *= int(s)
