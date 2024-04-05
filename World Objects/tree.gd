extends StaticBody2D


var totalTime: int = 5
var currentTime: int
var unitsCount: int = 0

@onready var bar: ProgressBar = $ProgressBar
@onready var timer: Timer = $Timer


func _ready():
	currentTime = totalTime
	bar.max_value = totalTime


func _process(_delta):
	if currentTime <= 0:
		tree_chopped()


func _on_chop_area_body_entered(body):
	if "Unit" in body.name:
		unitsCount += 1
		start_chopping()


func _on_chop_area_body_exited(body):
	if "Unit" in body.name:
		unitsCount -= 1
		if unitsCount <= 0:
			timer.stop()


func _on_timer_timeout():
	var shopSeed = 1 * unitsCount
	currentTime -= shopSeed
	var tween = get_tree().create_tween()
	tween.tween_property(bar, "value", currentTime, 0.5).set_trans(Tween.TRANS_LINEAR)


func tree_chopped():
	Game.Wood += 1
	var mini_map_node: SubViewport = get_tree().get_root().get_node("World/UI/MiniMap/SubViewportContainer/SubViewport")
	mini_map_node.update_trees()
	queue_free()


func start_chopping():
	timer.start()
