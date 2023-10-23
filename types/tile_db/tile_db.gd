@tool
class_name TileDB extends GameDB


var Main := load("res://types/tile_db/main.tscn") as PackedScene


func _get_name() -> String:
	return "瓷砖"


func _get_icon(interface: EditorInterface) -> Texture2D:
	return interface.get_base_control().get_icon("TileSet", "EditorIcons")


func _get_control(_interface: EditorInterface) -> Control:
	var control := Main.instantiate() as Control
	control.load_db(self)
	return control
