extends TextureRect

const ItemNode = preload("res://types/item/item_node.tscn")

func update_item(item):
	if item is Item:
		var item_node = ItemNode.instance()
		item_node.texture = item.texture
		add_child(item_node)
	else:
		for child_node in get_children():
			child_node.queue_free()

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")
	
func drop_data(_position, data):
	var this_slot_index = get_index()
	var current_drop_index = data.item_index
	get_parent().space.swap_item(current_drop_index, this_slot_index)
	get_parent().space.set_item(this_slot_index, data.item)
