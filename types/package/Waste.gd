extends TextureRect

const ItemMove = preload("res://types/item/batch_move_item_ui.tscn")

func _can_drop_data(_position, data):
	return data is Dictionary and data.has("item")
	
func _drop_data(_position, data):
	# 弹窗确认删除
	var move_window = ItemMove.instantiate()
	move_window.item = data.item.item
	move_window.num = data.item.num
	move_window.set_position(Vector2.ZERO)
	get_tree().get_root().add_child(move_window)
	var num = await move_window.check
	if num == 0:
		return
	if num == data.item.num:
		# 全部删除
		data.space.remove_item(data.item_index)
	else:
		# 部分删除
		data.item.num -= num
		
