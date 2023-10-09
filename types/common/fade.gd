extends Sprite

func _ready():

	fade_out(1,0.5)

func fade_out(duration: float, delay: float):
	var fade = Tween.new()
	var timer = Timer.new()
	timer.connect("timeout", self, "_on_Timer_timeout")
	fade.interpolate_property(self, "modulate", self.modulate, Color(1, 1, 1, 0), duration, Tween.TRANS_LINEAR, Tween.EASE_IN, delay)
	add_child(fade)
	fade.start()
	timer.start(duration + delay)

func _on_Timer_timeout():
	queue_free()
