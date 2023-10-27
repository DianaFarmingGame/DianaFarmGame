extends GridContainer

@export var space: ItemSpace

var highlight_slot: TextureButton

func _ready():
	space.connect("items_changed", Callable(self, "on_items_changed"))
	space.init()
	for item_index in space.items.size():
		updata_space(item_index)
		
func _process(delta):
	if space.space_name == "short_cut":
		if Input.is_action_pressed("0"):
			change_used(9)
		if Input.is_action_pressed("1"):
			change_used(0)
		if Input.is_action_pressed("2"):
			change_used(1)
		if Input.is_action_pressed("3"):
			change_used(2)
		if Input.is_action_pressed("4"):
			change_used(3)
		if Input.is_action_pressed("5"):
			change_used(4)
		if Input.is_action_pressed("6"):
			change_used(5)
		if Input.is_action_pressed("7"):
			change_used(6)
		if Input.is_action_pressed("8"):
			change_used(7)
		if Input.is_action_pressed("9"):
			change_used(8)

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

func add_item(item: Node) -> bool:
	print("add item")
	var index = space.get_first_empty_slot()
	if index == -1:
		#空间已满
		return false
	space.set_item(index, item)
	return true

func change_used(index: int):
	if highlight_slot != null:
		highlight_slot.button_pressed = false
	highlight_slot = get_child(index)
	highlight_slot.button_pressed = true
