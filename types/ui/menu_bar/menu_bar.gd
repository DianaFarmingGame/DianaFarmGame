tool
class_name MenuBar extends GControl
# 包含一组 GMenuButton 的 HBoxContainer ，可以直接用 set_menus 方法设置菜单栏的内容
# 具体的使用示例请参考 "res://types/tile_db/main.gd"


const Main := preload("./main.tscn")

var box: HBoxContainer


func _ready() -> void:
	._ready()
	box = $"Box"


# 将目标设置为菜单事件的发送对象（已弃用，请对每个菜单项单独绑定）
#func connect_signals(ptarget: Object) -> void:
#	target = weakref(ptarget)
#	for child in box.get_children():
#		var button := child as GMenuButton
#		button.connect_signals(ptarget)


# 设置菜单栏的内容
# menus: {...String<菜单的名称>: Menu}
# Menu: <同 GMenuButton.set_menu 的参数>
func set_menus(menus: Dictionary) -> void:
	var cur_size := box.get_child_count()
	var tar_size := menus.size()
	if tar_size > cur_size:
		# 添加不足的菜单按钮
		for _i in tar_size - cur_size:
			var button := GMenuButton.new()
			button.switch_on_hover = true
			box.add_child(button)
	else:
		# 删除多余的菜单按钮
		var removes := box.get_children().slice(tar_size, cur_size)
		for child in removes:
			box.remove_child(child)
			child.queue_free()
	var idx := 0
	for key in menus.keys():
		var menu := menus.get(key) as Array
		var button := box.get_child(idx) as GMenuButton
		button.text = key
		button.set_menu(menu)
		idx += 1


func _get_control() -> Control:
	return Main.instance() as Control
