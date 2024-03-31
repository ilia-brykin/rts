extends StaticBody2D


var _mouse_entered: bool = false
var selected: bool = false

@onready var select: Panel = $Selected


func _process(_delta):
	select.visible = selected


func _input(event):
	if event.is_action_pressed("LeftClick"):
		if _mouse_entered == true:
			selected = !selected
			if selected:
				Game.spawn_unit(position)


func _on_mouse_entered():
	_mouse_entered = true


func _on_mouse_exited():
	_mouse_entered = false
