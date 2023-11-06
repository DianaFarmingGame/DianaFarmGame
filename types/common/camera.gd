extends Camera2D

func _process(delta):
	var target_position
	if traveler.is_control:
		target_position = traveler.position
	else :
		target_position = diana.position
	position = position.lerp(target_position, 0.1)
