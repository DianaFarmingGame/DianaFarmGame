@tool
extends EditorPlugin


var editor_interface: EditorInterface


func _init() -> void:
	editor_interface = get_editor_interface()
	if EditorIcon:
		EditorIcon.editor_interface = editor_interface


func _enter_tree():
	add_autoload_singleton("EditorIcon", "res://addons/editor_icon/editor_icon.gd")
	EditorIcon.editor_interface = editor_interface


func _exit_tree():
	remove_autoload_singleton("EditorIcon")
