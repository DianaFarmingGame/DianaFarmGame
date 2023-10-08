extends TextureButton

const ItemNode = preload("res://types/item/item_node.tscn")

func _ready():
	self.connect("pressed", self, "_on_button_pressed")

func update_item(item):
	if item is Item:
		var item_node = ItemNode.instance()
		# 设置item展示的图片和描述
		item_node.texture = item.texture
		item_node.get_child(0).text = item.name
		add_child(item_node)
	else:
		for child_node in get_children():
			child_node.queue_free()

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")
	
func drop_data(_position, data):
	var this_slot_index = get_index()
	var current_slot_item = get_parent().space.get_item(this_slot_index)
	get_parent().space.set_item(this_slot_index, data.item)
	data.space.set_item(data.item_index, current_slot_item)

func _on_button_pressed():
	if get_parent().highlight_slot != null:
		get_parent().highlight_slot.pressed = false
	get_parent().highlight_slot = self
