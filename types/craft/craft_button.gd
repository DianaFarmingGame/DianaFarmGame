extends Button

const ItemNode = preload("res://types/item/item_node.tscn")

var craft_table = preload("res://dbs/craft/craft_table.tres")
var craft_forbidden = preload("res://types/craft/craft_forbidden.tscn")

func _ready():
	var button = $"."
	button.connect("pressed", Callable(self, "on_button_pressed"))

func on_button_pressed():
	var input_space = $"../InputSlot".space
	var input_items = input_space.items
	var input_item_name_list = PackedStringArray()
	for item in input_items:
		if item != null:
			input_item_name_list.append(item.item.name)
	var item_names = "+".join(input_item_name_list)
	var output_items = craft_table.get_craft_result(item_names)
	var output_space = $"../OutputSlot".space
	if output_items != null:
		#如果输出栏中有物品未取出，则合成失败
		if output_space.used_volumn > 0:
			var instance = craft_forbidden.instantiate()
			$"..".add_child(instance)
			return
		for index in output_items.size():
			var node = ItemNode.instantiate()
			node.item = output_items[index]
			node.num = 1
			output_space.set_item(index, node)
		#清除输入栏
		input_space.clear()
	else:
		# 因为不存在该合成公式而导致合成失败
		var instance = craft_forbidden.instantiate()
		$"..".add_child(instance)
