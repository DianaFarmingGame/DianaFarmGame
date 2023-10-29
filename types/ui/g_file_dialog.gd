@tool
class_name GFileDialog extends EditorFileDialog


signal completed(result)


func select_file(ptitle: String, pfilters: Array) -> Variant:
	title = ptitle
	filters = PackedStringArray(pfilters)
	file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	popup_centered()
	file_selected.connect(func (path):
		completed.emit(path))
	canceled.connect(func ():
		completed.emit(null))
	var result = await completed
	hide()
	return result
