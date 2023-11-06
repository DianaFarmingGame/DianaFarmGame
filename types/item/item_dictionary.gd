extends Control

class_name ItemDictionary

const ItemNode = preload("res://types/item/item_node.tscn")

var item_dictionary: Dictionary = {}
var config_path = "res://config/item.cfg"
var fields: Array = ["hp","mp","consumable","texture","world_texture","tool","blind_box"]

func _init():
	load_config()

func load_config():
	var item_data = ConfigLoader.load_config(config_path,fields)
	for item in item_data:
		var item_name = item
		var hp = item_data[item]["hp"]
		var mp = item_data[item]["mp"]
		var consumable = item_data[item]["consumable"]
		var texture = item_data[item]["texture"]
		var world_texture = item_data[item]["world_texture"]
		var tool_name = item_data[item].get("tool")
		var blind_box_config_path = item_data[item].get("blind_box")
		var tool
		var blind_box
		if tool_name:
			tool = ToolSet.tools.get(tool_name)
		if blind_box_config_path:
			blind_box = BlindBox.new(blind_box_config_path)
		var item_type = Item.new(item_name,hp,mp,consumable,texture,world_texture,tool,blind_box)
		item_dictionary[item] = item_type
