extends TextureButton

const ItemNode = preload("res://types/item/item_node.tscn")
const ItemMove = preload("res://types/item/batch_move_item_ui.tscn")


func _ready():
	self.connect("pressed", Callable(self, "_on_button_pressed"))

func update_item(item):
	if item is Node:
		if item.get_parent():
			item.get_parent().remove_child(item)
		add_child(item)
	else:
		for child_node in get_children():
			child_node.queue_free()

func _can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

func _drop_data(_position, data):
	var cur_space = get_parent().space
	var this_slot_index = get_index()
	var current_slot_item = cur_space.get_item(this_slot_index)
	# 弹窗条件 1.物品数量大于1 2.跨物品空间移动 3.目的地为空格子 4.仅在指定的空间之间移动需要弹窗
	if data["item"].num > 1 && data["space"] != cur_space && current_slot_item == null \
	 && need_select(data["space"].space_name, cur_space.space_name):
		var move_window = ItemMove.instantiate()
		move_window.item = data.item.item
		move_window.num = data.item.num
#		move_window.set_position(Vector2.ZERO)
		ui.add_child(move_window)
		var move_num = await move_window.check
		if move_num == 0:
			return
		if move_num < data.item.num:
			var move_item = ItemNode.instantiate()
			move_item.item = data.item.item
			move_item.num = move_num
			data.item.num -= move_num
			get_parent().space.set_item(this_slot_index, move_item)
			return
	var is_overlie = get_parent().space.set_item(this_slot_index, data.item)
	# 如果触发了堆叠就不需要换位了，直接置空
	if !is_overlie:
		data.space.set_item(data.item_index, current_slot_item)
	else :
		data.space.set_item(data.item_index, null)

func _on_button_pressed():
	get_parent().change_used(get_index())
	
func need_select(origin, source):
	# 需要弹出数量选择窗口
	var map = {
		"short_cut" : "craft_input",
		"package" : "craft_input",
	}
	if map.get(origin) == source:
		return true
	else:
		return false
