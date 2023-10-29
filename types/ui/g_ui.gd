class_name GUI extends RefCounted


static func Margin(margin: int, items := []) -> MarginContainer:
	var node := MarginContainer.new()
	node.add_theme_constant_override("offset_top", margin)
	node.add_theme_constant_override("offset_left", margin)
	node.add_theme_constant_override("offset_right", margin)
	node.add_theme_constant_override("offset_bottom", margin)
	return with_append(with_fill(node), items) as MarginContainer


static func VBox(items := [], align := BoxContainer.ALIGNMENT_BEGIN) -> VBoxContainer:
	var node := VBoxContainer.new()
	node.alignment = align
	return with_append(node, items) as VBoxContainer


static func HBox(items := [], align := BoxContainer.ALIGNMENT_BEGIN) -> HBoxContainer:
	var node := HBoxContainer.new()
	node.alignment = align
	return with_append(node, items) as HBoxContainer


static func GButton(text: String, handle = null) -> Button:
	var node := Button.new()
	node.text = text
	if handle:
		node.pressed.connect(handle)
	return node


static func with_append(node: Node, items: Array) -> Node:
	for item in items:
		node.add_child(item)
	return node


static func with_fill(node: Control) -> Control:
	node.set_anchors_preset(Control.PRESET_FULL_RECT)
	return node
