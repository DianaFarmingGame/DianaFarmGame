@tool
class_name EditorIconTexture extends AtlasTexture
# 一种 Texture，可以直接设置使用编辑器自带的图标，无法在游戏中使用（仅插件用）


@export var icon_name: String: set = set_icon_name


#func _init() -> void:
#	EditorIcon.sign(self)
#	update()


func update() -> void:
	if atlas == null:
		atlas = EditorIcon.get_icon(icon_name)
		if icon_name and atlas != null:
			region = Rect2(Vector2(0, 0), atlas.get_size())
			atlas.resource_path = "res://addons/editor_icon/icons/" + icon_name + ".res"
		emit_changed()


func set_icon_name(name: String) -> void:
	if name != icon_name:
		if icon_name:
			atlas = null
		icon_name = name
		update()
