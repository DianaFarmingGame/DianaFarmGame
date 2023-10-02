tool
class_name GControl extends Control


func _ready() -> void:
	var control = _get_control()
	control.set_anchors_preset(Control.PRESET_WIDE)
	add_child(control)


# 获取控件的节点（通常从PackedScene实例化）
func _get_control() -> Control:
	return Control.new()
