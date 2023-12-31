@tool
class_name GMenuButton extends MenuButton
# 修改后的菜单按钮，可以直接用 set_menu 方法设置菜单的内容，并提供直观的点击绑定


var menu: Array

@onready var popup := get_popup()


static func _unbind_handle(label: String) -> void:
	print("unbind menu entry: ", label)


func _ready() -> void:
	popup.connect("id_pressed", Callable(self, "_on_id_pressed"))


# 设置弹出的菜单
# pmenu: [...Entry]
# Entry: <调用 GMenuButton.Item 等方法的返回值>
func set_menu(pmenu: Array) -> void:
	popup.clear()
	for entry in pmenu:
		match entry[0]:
			GMenu.EntryType.ITEM:
				popup.add_item(entry[1])
			GMenu.EntryType.SEPARATOR:
				popup.add_separator(entry[1])
	menu = pmenu


func _on_id_pressed(idx: int) -> void:
	var entry := menu[idx] as Array
	match entry[0]:
		GMenu.EntryType.ITEM:
			var ref := entry[2] as Callable
			if ref && ref.is_valid():
				ref.callv(entry[3])
			else:
				GMenuButton._unbind_handle(entry[1])
