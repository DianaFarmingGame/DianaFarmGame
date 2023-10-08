tool
class_name ItemDB extends GameDB


var Main := load("res://types/item/item_editor.tscn") as PackedScene


func _get_name() -> String:
	return "物品"


func _get_icon(interface: EditorInterface) -> Texture:
	return interface.get_base_control().get_icon("TileSet", "EditorIcons")


func _get_control(_interface: EditorInterface) -> Control:
	var control := Main.instance() as Control
	return control
