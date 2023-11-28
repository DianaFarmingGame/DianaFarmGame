extends Node

class_name CraftTable

# 已经学会的合成公式
var formulas = {}

var config_path = "res://config/craft_formulas.cfg"
var fields: Array = ["inputs","outputs","level","tag"]
var craft_dict = {}
var level

func _init():
	load_config()
	level = 0
	learn(0,"default")
	print(formulas)

func get_craft_result(inputs: String):
	print(inputs)
	if inputs in formulas:
		return formulas[inputs]
	else:
		return null

func load_config():
	var item_data = ConfigLoader.load_config(config_path,fields)
	for item in item_data:
		var inputs = item_data[item]["inputs"]
		var outputs = item_data[item]["outputs"]
		var level = item_data[item]["level"]
		var tag = item_data[item]["tag"]
		if craft_dict.get(level) == null:
			craft_dict[level] = {}
		if craft_dict[level].get(tag) == null:
			craft_dict[level][tag] = []
		craft_dict[level][tag].append([inputs,outputs])
		
func learn(level: int, tag: String):
	var level_craft_formulas = craft_dict.get(level)
	if level_craft_formulas == null:
		return
	if tag:
		var tag_craft_formulas = level_craft_formulas.get(tag)
		if tag_craft_formulas == null:
			return
		for craft_formula in tag_craft_formulas:
			var inputs = craft_formula[0]
			var outputs = craft_formula[1]
			var key = "+".join(inputs)
			formulas[key] = outputs
		return
	for tag_craft_formulas in level_craft_formulas:
		for craft_formula in tag_craft_formulas:
			var inputs = craft_formula[0]
			var outputs = craft_formula[1]
			var key = "+".join(inputs)
			formulas[key] = outputs
			
