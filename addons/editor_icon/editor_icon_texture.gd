tool
class_name EditorIconTexture extends ProxyTexture


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
