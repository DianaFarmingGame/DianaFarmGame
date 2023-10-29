@tool
class_name GMenu


enum EntryType {
	ITEM,
	SEPARATOR,
}


# 添加一个基本菜单项，同时将项目的点击事件与 target 的 handle 方法绑定，
# 可选可以传入额外的绑定参数
static func Item(label: String, handle = null, argv := []) -> Array:
	if handle:
		return [EntryType.ITEM, label, handle, argv]
	else:
		return [EntryType.ITEM, label, null]


# 添加一个分割线
static func Separator(label := "") -> Array:
	return [EntryType.SEPARATOR, label]
