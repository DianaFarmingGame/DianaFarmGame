class_name GLDialog
# 为了绕过 GDScript 愚蠢的依赖检查而诞生的类
# 提供了一些静态方法用于快捷使用 GDialog


static func prompt(title: String, info := "", text := "", placeholder := "") -> GDialog:
	var dialog := GDialog.new(title)
	var items := []
	if info:
		var label := Label.new()
		label.text = info
		items.append(label)
	var edit := LineEdit.new()
	edit.rect_min_size.x = 200
	edit.text = text
	edit.placeholder_text = placeholder
	items.append(edit)
	items.append(GUI.HBox([GUI.Button("确认", dialog, "_prompt_confirm", [edit])], 1))
	dialog.set_inner(items)
	dialog.connect("popup_hide", dialog, "do_resolve", [null])
	return dialog

