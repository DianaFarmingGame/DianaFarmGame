@tool
class_name GMenuPopup extends PopupMenu
# 修改后的菜单弹出框，可以直接用 set_menu 方法设置菜单的内容，并提供直观的点击绑定


var menu: Array


static func _unbind_handle(label: String) -> void:
	print("unbind menu entry: ", label)


func _ready() -> void:
	connect("id_pressed", Callable(self, "_on_id_pressed"))


# 设置弹出的菜单
# pmenu: [...Entry]
# Entry: <调用 GMenuButton.Item 等方法的返回值>
func set_menu(pmenu: Array) -> void:
	clear()
	for entry in pmenu:
		match entry[0]:
			GMenu.EntryType.ITEM:
				add_item(entry[1])
			GMenu.EntryType.SEPARATOR:
				add_separator(entry[1])
	menu = pmenu
	reset_size()


func _on_id_pressed(idx: int) -> void:
	var entry := menu[idx] as Array
	match entry[0]:
		GMenu.EntryType.ITEM:
			var ref := entry[2] as Callable
			if ref && ref.is_valid():
				ref.callv(entry[3])
			else:
				GMenuPopup._unbind_handle(entry[1])
