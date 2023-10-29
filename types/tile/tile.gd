@tool
class_name Tile extends GameDB


@export var name := "未命名"
@export var tags = []
@export var src_img := ""
@export var block_size := Vector2(1, 1)
@export var tile_size := Vector2(16, 16)
@export var mask_size := Vector2(1, 1)
@export var mask_set := []


func _get_name() -> String:
	return "Tile: " + name


func _get_icon(interface: EditorInterface) -> Texture2D:
	if ResourceLoader.exists(src_img, "Texture2D") and mask_set.size() > 0:
		var mask := mask_set[0] as TileMaskItem
		var texture := AtlasTexture.new()
		texture.atlas = load(src_img)
		texture.region = Rect2(mask.pos * tile_size, tile_size)
		return texture
	return interface.get_base_control().get_theme_icon("TileSet", "EditorIcons")


func _get_control(_interface: EditorInterface) -> Control:
	var control := load("res://types/tile/main.tscn").instantiate() as Control
	control.load_db(self)
	return control
