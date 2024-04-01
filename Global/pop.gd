extends Label

var travel: Vector2 = Vector2(0, -50)
var duration: int = 1
var speed: float = PI / 2


func show_value(value: int, crit: bool):
	var tween = create_tween()
	text = "+ " + str(value) + "g"
	pivot_offset = size / 4
	
	var movement = travel.rotated(randi_range(-speed / 2, speed / 2))
	
	tween.tween_property(self, "position", position + movement, duration)
	tween.tween_property(self, "modulate:a", 0.0, duration)
	
	if crit == true:
		modulate = Color(1, 0, 0)
		scale = scale * 2
		tween.tween_property(self, "scale", scale, 0.4)
	
	tween.play()
	tween.tween_callback(queue_free)
