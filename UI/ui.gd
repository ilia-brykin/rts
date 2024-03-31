extends CanvasLayer


@onready var label: Label = $Label


func _process(_delta):
	label.text = "Wood: " + str(Game.Wood)
