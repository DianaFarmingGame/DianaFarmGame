extends Camera2D

var max_distance = 150

func _ready():
	zoom = Vector2(3, 3)

func _process(delta):
#	var target_position
#	if traveler.is_control:
#		target_position = traveler.position
#	else :
#		target_position = diana.position
#	var distance = position.distance_to(target_position)
#	if distance > max_distance:
#		var move = target_position - position
#		position += move.normalized() * (distance - max_distance)
#		position = position.lerp(target_position, 0.02)

