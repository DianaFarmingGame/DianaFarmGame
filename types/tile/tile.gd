@tool
class_name Tile extends GameDB


@export var name := "未命名"

var Main := load("res://types/tile/main.tscn") as PackedScene


func _get_name() -> String:
	return "Tile: " + name


func _get_icon(interface: EditorInterface) -> Texture2D:
	return interface.get_base_control().get_theme_icon("TileSet", "EditorIcons")


func _get_control(_interface: EditorInterface) -> Control:
	var control := Main.instantiate() as Control
#	control.load_db(self)
	return control
