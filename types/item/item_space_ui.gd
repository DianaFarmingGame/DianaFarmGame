extends GridContainer

@export var space: Resource

var highlight_slot: TextureButton

func _ready():
	space.connect("items_changed", Callable(self, "on_items_changed"))
	space.init()
	for item_index in space.items.size():
		updata_space(item_index)

func updata_space(index):
	var slot = get_child(index)
	var item = space.items[index]
	if slot == null:
		print("[error] updata_space null slot")
		return
	slot.update_item(item)

func on_items_changed(indexs):
	for index in indexs:
		updata_space(index)
