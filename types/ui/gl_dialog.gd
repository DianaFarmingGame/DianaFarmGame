class_name GLDialog
# 为了绕过 GDScript 愚蠢的依赖检查而诞生的类
# 提供了一些静态方法用于快捷使用 GDialog


static func prompt(node: Node, title: String, info := "", text := "", placeholder := "") -> Variant:
	var dialog := GDialog.new(title)
	var items := []
	if info:
		var label := Label.new()
		label.text = info
		items.append(label)
	var edit := LineEdit.new()
	edit.custom_minimum_size.x = 200
	edit.text = text
	edit.placeholder_text = placeholder
	edit.text_submitted.connect(dialog.do_resolve)
	items.append(edit)
	items.append(GUI.HBox([GUI.GButton("确认", func ():
		dialog.do_resolve(edit.text))], BoxContainer.ALIGNMENT_CENTER))
	dialog.set_inner(items)
	dialog.close_requested.connect(dialog.do_resolve)
	node.add_child(dialog)
	dialog.open.call_deferred()
	edit.grab_focus.call_deferred()
	edit.select_all.call_deferred()
	var result = await dialog.resolved
	node.remove_child.call_deferred(dialog)
	dialog.queue_free.call_deferred()
	return result

class Eventer:
	signal completed(result)

static func select_file(node: Node, title: String, filters: Array) -> Variant:
	var eventer := Eventer.new()
	var dialog := EditorFileDialog.new()
	dialog.title = title
	dialog.filters = PackedStringArray(filters)
	dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	node.add_child(dialog)
	dialog.popup_centered()
	dialog.file_selected.connect(func (path):
		eventer.completed.emit(path))
	dialog.canceled.connect(func ():
		eventer.completed.emit(null))
	var result = await eventer.completed
	var after := func ():
		node.remove_child(dialog)
		dialog.queue_free()
	after.call_deferred()
	return result
