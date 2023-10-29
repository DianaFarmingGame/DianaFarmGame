class_name GDialog extends Window


signal resolved(result)

var margin: MarginContainer
var panel: PanelContainer
var is_resolved = false


func _init(ptitle: String) -> void:
	title = ptitle
	panel = PanelContainer.new()
	panel.anchors_preset = Control.PRESET_FULL_RECT
	panel.theme_type_variation = &"TabContainer"
	margin = GUI.Margin(8)
	panel.add_child(margin)
	add_child(panel)


func set_inner(items := []) -> void:
	for child in margin.get_children():
		margin.remove_child(child)
		child.queue_free()
	margin.add_child(GUI.VBox(items))


func open() -> void:
	popup_centered_clamped(panel.get_minimum_size())


func do_resolve(result = null) -> void:
	if is_inside_tree():
		if not is_resolved:
			is_resolved = true
			resolved.emit(result)

