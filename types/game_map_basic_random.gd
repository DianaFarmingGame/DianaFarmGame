class_name GameMapBasicRandom extends GameMapBasic


export var tile_id_min := 0
export var tile_id_max := 1
export var tile_id_base := 1
export var base_height := 1
export var rand_height := 1
export var random_seed := 0


func _init_data() -> void:
	._init_data()
	
	# fill base
	for i in range(base_height):
		var layer_data := map_data[i] as Array
		layer_data.fill(tile_id_base)
	
	# fill rand
	seed(random_seed)
	for i in range(base_height, base_height + rand_height):
		var layer_data := map_data[i] as Array
		for idx in range(layer_data.size()):
			layer_data[idx] = randi() % (tile_id_max - tile_id_min + 1) + tile_id_min
