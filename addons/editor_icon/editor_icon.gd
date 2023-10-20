@tool
extends Node


var signed_textures := []
var editor_interface: EditorInterface: set = set_editor_interface


func rsign(texture: EditorIconTexture) -> void:
	signed_textures.append(weakref(texture))


func get_icon(name: String):
	if editor_interface:
		var control = editor_interface.get_base_control()
		if control.has_theme_icon(name, "EditorIcons"):
			return editor_interface.get_base_control().get_theme_icon(name, "EditorIcons")
	return null


func set_editor_interface(interface: EditorInterface) -> void:
	editor_interface = interface
	for texture_ref in signed_textures.duplicate():
		var texture := texture_ref.get_ref() as EditorIconTexture
		if texture:
			texture.update()
		else:
			signed_textures.erase(texture_ref)
