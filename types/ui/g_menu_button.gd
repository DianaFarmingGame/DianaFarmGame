tool
class_name GMenuButton extends MenuButton
# 修改后的菜单按钮，可以直接用 set_menu 方法设置菜单的内容，并提供直观的点击绑定


enum EntryType {
	ITEM
	SEPARATOR
}

var menu: Array

onready var popup := get_popup()


# 添加一个基本菜单项，同时将项目的点击事件与 target 的 handle 方法绑定，
# 可选可以传入额外的绑定参数
static func Item(label: String, target = null, handle := "", argv := []) -> Array:
	if target:
		return [EntryType.ITEM, label, funcref(target, handle), argv]
	else:
		return [EntryType.ITEM, label, null]


# 添加一个分割线
static func Separator(label := "") -> Array:
	return [EntryType.SEPARATOR, label]


static func _unbind_handle(label: String) -> void:
	print("unbind menu entry: ", label)


func _ready() -> void:
	popup.connect("id_pressed", self, "_on_id_pressed")


# 设置弹出的菜单
# pmenu: [...Entry]
# Entry: <调用 GMenuButton.Item 等方法的返回值>
func set_menu(pmenu: Array) -> void:
	popup.clear()
	for entry in pmenu:
		match entry[0]:
			EntryType.ITEM:
				popup.add_item(entry[1])
			EntryType.SEPARATOR:
				popup.add_separator(entry[1])
	menu = pmenu


func _on_id_pressed(idx: int) -> void:
	var entry := menu[idx] as Array
	match entry[0]:
		EntryType.ITEM:
			var ref := entry[2] as FuncRef
			if ref && ref.is_valid():
				ref.call_funcv(entry[3])
			else:
				self._unbind_handle(entry[1])
