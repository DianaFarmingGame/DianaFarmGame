@tool
class_name GControl extends Control


@onready var control := _get_control()


func _ready() -> void:
	control.set_anchors_preset(Control.PRESET_WIDE)
	control.connect("minimum_size_changed", Callable(self, "_on_min_size_changed"))
	add_child(control)
	_on_min_size_changed()


# 获取控件的节点（通常从PackedScene实例化）
func _get_control() -> Control:
	return Control.new()


func _get_minimum_size() -> Vector2:
	if control:
		return control.get_minimum_size()
	else:
		return Vector2()


func _on_min_size_changed() -> void:
	minimum_size_changed()
