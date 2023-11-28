extends Control

class_name ItemDictionary

const ItemNode = preload("res://types/item/item_node.tscn")

var item_dictionary: Dictionary = {}
var config_path = "res://config/item.cfg"

var fields: Array = ["hp","mp","consumable","texture","world_texture","tool","blind_box","is_food",
					"durability_limit","durability","is_zero_durability_be_destroy"]

func _init():
	load_config()

func load_config():
	var item_data = ConfigLoader.load_config(config_path,fields)
	for item in item_data:
		var item_name = item
		var hp = item_data[item].get("hp", 0)
		var mp = item_data[item].get("mp", 0)
		var consumable = item_data[item].get("consumable", true)
		var is_food = item_data[item].get("is_food", false)
		var texture = item_data[item]["texture"]
		var world_texture = item_data[item]["world_texture"]
		var tool_name = item_data[item].get("tool")
		var blind_box_config_path = item_data[item].get("blind_box")
		var durability_limit = item_data[item].get("durability_limit", 0)
		var durability = item_data[item].get("durability", 0)
		var is_zero_durability_be_destroy = item_data[item].get("is_zero_durability_be_destroy", false)
		var tool
		var blind_box
		if tool_name:
			tool = ToolSet.tools.get(tool_name)
		if blind_box_config_path:
			blind_box = BlindBox.new(blind_box_config_path)
		var item_type = Item.new(item_name,hp,mp,consumable,texture,world_texture,tool,blind_box,is_food,
								durability_limit,durability,is_zero_durability_be_destroy)
		item_dictionary[item] = item_type
