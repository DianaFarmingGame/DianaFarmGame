class_name GLDialog
# 为了绕过 GDScript 愚蠢的依赖检查而诞生的类
# 提供了一些静态方法用于快捷使用 GDialog


static func prompt(node: Node, title: String, info := "", text := "", placeholder := "") -> GDialog:
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
	edit.connect("text_submitted", Callable(dialog, "do_resolve"))
	items.append(edit)
	items.append(GUI.HBox([GUI.GButton("确认", dialog, "_prompt_confirm", [edit])], 1))
	dialog.set_inner(items)
	dialog.connect("popup_hide", Callable(dialog, "do_resolve").bind(null))
	node.add_child(dialog)
	dialog.open()
	edit.call_deferred("grab_focus")
	var result = await dialog.resolved
	node.remove_child(dialog)
	dialog.queue_free()
	return result

