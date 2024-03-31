extends Camera2D

signal area_selected
signal atart_move_selection

@export var SPEED: float = 20.0
@export var ZOOM_SPEED: float = 20.0
@export var ZOOM_MARGIN: float = 0.1
@export var ZOOM_MIN: float = 0.5
@export var ZOOM_MAX: float = 3.0

var zoomFactor: float = 1.0
var zoomPos: Vector2 = Vector2()
var zooming: bool = false

var mousePos: Vector2 = Vector2()
var mousePosGlobal: Vector2 = Vector2()
var start: Vector2 = Vector2()
var startV: Vector2 = Vector2()
var end: Vector2 = Vector2()
var endV: Vector2 = Vector2()
var isDragging: bool = false

@onready var box: Panel = get_node("../UI/Panel")


func _ready():
	connect("area_selected", Callable(get_parent(), "_on_area_selected"))


func _process(delta):
	zoom_camera(delta)
	move_camera(delta)
	
	process_select_area()


func zoom_camera(delta: float) -> void:
	zoom.x = lerp(zoom.x, zoom.x * zoomFactor, ZOOM_SPEED * delta)
	zoom.y = lerp(zoom.y, zoom.y * zoomFactor, ZOOM_SPEED * delta)
	
	zoom.x = clamp(zoom.x, ZOOM_MIN, ZOOM_MAX)
	zoom.y = clamp(zoom.y, ZOOM_MIN, ZOOM_MAX)
	if not zooming:
		zoomFactor = 1.0


func move_camera(delta: float) -> void:
	var inputX: int = get_input_x()
	var inputY: int = get_input_y()
	
	position.x = lerp(position.x, position.x + inputX * SPEED * zoom.x, SPEED * delta)
	position.y = lerp(position.y, position.y + inputY * SPEED * zoom.y, SPEED * delta)


func get_input_x() -> int:
	return int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	
	
func get_input_y() -> int:
	return int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))


func process_select_area() -> void:
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
			emit_signal("area_selected", self)
		else:
			end = start
			isDragging = false
			draw_area(false)
	

func _input(event: InputEvent) -> void:
	input_for_zoom(event)
	
	if event is InputEventMouse:
		mousePos = event.position
		mousePosGlobal = get_global_mouse_position()


func input_for_zoom(event: InputEvent) -> void:
	if abs(zoomPos.x - get_global_mouse_position().x) > ZOOM_MARGIN:
		zoomFactor = 1.0
	if abs(zoomPos.y - get_global_mouse_position().y) > ZOOM_MARGIN:
		zoomFactor = 1.0
		
	if event is InputEventMouseButton:
		if event.is_pressed():
			zooming = true
			if event.is_action("WheelDown"):
				zoomFactor -= 0.01 * ZOOM_SPEED
				zoomPos = get_global_mouse_position()
			if event.is_action("WheelUp"):
				zoomFactor += 0.01 * ZOOM_SPEED
				zoomPos = get_global_mouse_position()
		else:
			zooming = true


func draw_area(s: bool = true) -> void:
	box.size = Vector2(abs(startV.x - endV.x), abs(startV.y - endV.y))
	var pos = Vector2()
	pos.x = min(startV.x, endV.x)
	pos.y = min(startV.y, endV.y)
	box.position = pos
	box.size *= int(s)
