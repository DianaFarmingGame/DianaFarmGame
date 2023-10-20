extends Resource

class_name ItemSpace

@export var items # (Array,Resource)

signal items_changed(indexs)

func set_item(index, item):
	var current_item = items[index]
	items[index] = item
	emit_signal("items_changed",[index])
	return current_item
	
func remove_item(index):
	var current_item = items[index]
	items[index] = null
	emit_signal("items_changed",[index])
	return current_item

func swap_item(origin_index, target_index):
	var target_item = items[target_index]
	items[target_index] = items[origin_index]
	items[origin_index] = target_item
	emit_signal("items_changed",[origin_index, target_index])
