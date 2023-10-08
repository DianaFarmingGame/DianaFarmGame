extends Button

var craft_table = preload("res://dbs/craft/craft_table.tres")

func _ready():
	var button = $"."
	button.connect("pressed", self, "on_button_pressed")

func on_button_pressed():
	var input_items = $"../InputSlot".space.items
	var input_item_name_list = PoolStringArray()
	for item in input_items:
		if item != null:
			input_item_name_list.append(item.name)
	var item_names = input_item_name_list.join("+")
	var output_items = craft_table.get_craft_result(item_names)
	print(output_items)
	var output_space = $"../OutputSlot".space
	print(output_space.items)
	if output_items != null:
		#TODO 如果输出栏中有物品，则将其放回背包
		for index in output_items.size():
			output_space.set_item(index, output_items[index])
		#TODO 清除输入栏
