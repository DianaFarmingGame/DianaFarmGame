class_name GDialog extends Window


signal resolved(result)

var margin: MarginContainer
var is_resolved = false


func _init(ptitle: String) -> void:
	title = ptitle
	margin = GUI.Margin(8)
	add_child(margin)


func set_inner(items := []) -> void:
	for child in margin.get_children():
		margin.remove_child(child)
		child.queue_free()
	margin.add_child(GUI.VBox(items))


func open() -> void:
	popup_centered_clamped(margin.get_minimum_size())


func do_resolve(result = null) -> void:
	if not is_resolved:
		is_resolved = true
		emit_signal("resolved", result)


func _prompt_confirm(edit: LineEdit) -> void:
	do_resolve(edit.text)
	visible = false
