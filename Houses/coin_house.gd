extends StaticBody2D

var POP: PackedScene = preload("res://Global/pop.tscn")

var totalTime: int = 50
var currentTime: int

@onready var bar: ProgressBar = $ProgressBar
@onready var timer: Timer = $Timer

func _ready():
	currentTime = totalTime
	bar.max_value = totalTime
	timer.start()


func _process(_delta):
	if currentTime <= 0:
		coins_collected()


func _on_timer_timeout() -> void:
	currentTime -= 1
	var tween = get_tree().create_tween()
	tween.tween_property(bar, "value", currentTime, 0.1).set_trans(Tween.TRANS_LINEAR)


func coins_collected() -> void:
	Game.coin += 10
	_ready()
	var pop_instance: Label = POP.instantiate()
	add_child(pop_instance)
	pop_instance.show_value(10, false)
