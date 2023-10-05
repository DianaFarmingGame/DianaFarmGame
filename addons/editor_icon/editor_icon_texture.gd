tool
class_name EditorIconTexture extends ProxyTexture
# 一种 Texture，可以直接设置使用编辑器自带的图标，无法在游戏中使用（仅插件用）


export var icon_name: String setget set_icon_name


#func _init() -> void:
#	EditorIcon.sign(self)
#	update()


func update() -> void:
	if base == null:
		base = EditorIcon.get_icon(icon_name)
		if icon_name and base != null:
			base.resource_path = "res://addons/editor_icon/icons/" + icon_name + ".res"
		emit_changed()


func set_icon_name(name: String) -> void:
	if name != icon_name:
		if icon_name:
			base = null
		icon_name = name
		update()
