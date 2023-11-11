extends Resource

class_name CraftTable

var formulas = {}

var config_path = "res://config/craft_formulas.cfg"
var fields: Array = ["inputs","outputs","level","texture","world_texture","tool","blind_box"]

func _ready():
	pass

func get_craft_result(inputs: Array):
	print(inputs)
	if inputs in formulas:
		return formulas[inputs]
	else:
		return null

func load_config():
	var item_data = ConfigLoader.load_config(config_path,fields)
	for item in item_data:
		var item_name = item
		var hp = item_data[item]["hp"]
