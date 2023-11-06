extends Node

class_name BlindBox

var random_items

var fields: Array = ["probability","min","max"]
var config_path

const ItemNode = preload("res://types/item/item_node.tscn")

func _init(path):
	config_path = path
	random_items = ConfigLoader.load_config(config_path, fields)

# 开启盲盒，获取道具list
func open():
	var ret_list = []
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
			var node = ItemNode.instantiate()
			node.item = item_dic.item_dictionary.get(item)
			node.num = random_int
			ret_list.append(node)
	return ret_list
