extends Control

class_name BlindBox

var random_items

var fields: Array = ["probability","min","max"]
var config_path = "res://config/blind_box_type_1.cfg"

func _ready():
	random_items = ConfigLoader.load_config(config_path, fields)
	open()
	
func open():
	for item in random_items:
		var probability = random_items[item]["probability"]
		var min = random_items[item]["min"]
		var max = random_items[item]["max"]
		#随机获取一个0-1之间的float
		var random_float = randf()
		if random_float < probability:
			#在[min,max]中随机获取一个整数
			var random_int = min
			if max > min:
				random_int = randi() % (max - min + 1) + min
			print(item)
			print(random_int)
