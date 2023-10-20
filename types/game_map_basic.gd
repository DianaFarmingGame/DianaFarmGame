class_name GameMapBasic extends GameMap


@export var fallback_tile_id := 0


var map_data: Array


func _init_data() -> void:
	var data := []
	data.resize(map_height)
	for i in range(data.size()):
		var layer_data := []
		layer_data.resize(int(map_size.x * map_size.y))
		layer_data.fill(fallback_tile_id)
		data[i] = layer_data
	map_data = data
