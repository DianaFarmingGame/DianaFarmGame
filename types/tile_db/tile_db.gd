@tool
class_name TileDB extends GameDB


var Main := load("res://types/tile_db/main.tscn") as PackedScene
var tags: Array[String]
var tiles: Array[Tile]


func _init() -> void:
	refresh()


func _get_name() -> String:
	return "瓷砖"


func _get_icon(interface: EditorInterface) -> Texture2D:
	return interface.get_base_control().get_theme_icon("TileSet", "EditorIcons")


func _get_control(interface: EditorInterface) -> Control:
	var control := Main.instantiate() as Control
	control.editor_interface = interface
	control.load_db(self)
	return control


func refresh() -> void:
	tiles = []
	
	var path := "res://tiles"
	var dir := DirAccess.open(path)
	if dir != null:
		dir.list_dir_begin()
		while true:
			var node := dir.get_next()
			if node == "":
				break
			var file_path := path.path_join(node)
			if not dir.current_is_dir():
				if file_path.split(".")[-2] == "gtile":
					var res := ResourceLoader.load(file_path, "", ResourceLoader.CACHE_MODE_IGNORE)
					res.take_over_path(file_path)
					if res is Tile:
						var tile := res as Tile
						tiles.push_back(tile)
	
	for i in tiles.size():
		var tile := tiles[i]
		tile.need_save.connect(func (): _on_save_tile(i))
		for tag in tile.tags:
			if not tags.has(tag):
				tags.append(tag)
	
	changed.emit()


func _on_save_tile(idx) -> void:
	print("save: ", tiles[idx].name)
	ResourceSaver.save(tiles[idx])
