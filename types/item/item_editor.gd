tool
extends Control

var item_dictionary: ItemDictionary = preload("res://dbs/item/item_dictionary.tres")

func _ready():
	update()
	var add_button = $Panel/AddButton
	add_button.connect("pressed", self, "_on_add_button_pressed")
	var save_button = $Panel/SaveButton
	save_button.connect("pressed", self, "_on_save_button_pressed")


func _on_add_button_pressed():
	print("add item")
	var empty_item = Item.new()
	item_dictionary.add_item(empty_item)
	update()

func _on_save_button_pressed():
	print("save item")
	

func update():
	var grid = $"%GridContainer"
	# 获取子节点数量
	var child_count = grid.get_child_count()

	# 循环删除所有子节点
	for i in range(child_count):
		var child = grid.get_child(i)
		child.queue_free()

	var items = item_dictionary.get_all_item()
	for item in items:
		var texture_rect = TextureRect.new()
		texture_rect.texture = item.texture
		var name_edit = LineEdit.new()
		name_edit.text = item.name
		var hp_edit = SpinBox.new()
		hp_edit.value = item.hp
		var mp_edit = SpinBox.new()
		mp_edit.value = item.mp

		grid.add_child(name_edit)
		grid.add_child(texture_rect)
		grid.add_child(hp_edit)
		grid.add_child(mp_edit)

func edit_name(item_name: String, new_name: String):
	var item:Item = item_dictionary.get_item(item_name)
	item.name = new_name
	item_dictionary.edit_item(item_name, item)
	
