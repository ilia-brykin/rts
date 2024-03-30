extends CharacterBody2D

@export var selected: bool = false
@onready var box: Panel = $Box


func _ready():
	set_selected(selected)


func set_selected(_visible: bool):
	box.visible = _visible
