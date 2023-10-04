tool
extends EditorPlugin


const MainPanel = preload("./main.tscn")

var main_panel_instance
var editor_interface: EditorInterface


func _init() -> void:
	editor_interface = get_editor_interface()
	main_panel_instance = MainPanel.instance()
	main_panel_instance.editor_interface = editor_interface


func _enter_tree():
	editor_interface.get_editor_viewport().add_child(main_panel_instance)
	connect("resource_saved", self, "_on_resource_saved")
	make_visible(false)


func _exit_tree():
	if main_panel_instance:
		main_panel_instance.queue_free()


func has_main_screen():
	return true


func make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible


func get_plugin_name():
	return "Map"


func get_plugin_icon():
	return editor_interface.get_base_control().get_icon("AtlasTexture", "EditorIcons")


func _on_resource_saved(res: Resource) -> void:
	if res is Environment or res is GameMap:
		print("saved")
