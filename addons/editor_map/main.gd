tool
extends Control


var editor_interface: EditorInterface


onready var menu_file := $"%MenuFile" as MenuButton
onready var tree := $"%Tree" as Tree


func _ready():
	menu_file.get_popup().connect("id_pressed", self, "_on_menu_file_pressed")
	tree.connect("item_activated", self, "_on_tree_actived")
	update_list()


func update_list():
	tree.clear()
	var root := tree.create_item()
	root.set_text(0, "res://")
	root.set_icon(0, _get_editor_icon("Folder"))
	_update_list_recr("res://", tree, root)

func _update_list_recr(path: String, tree: Tree, par: TreeItem) -> bool:
	var dir := Directory.new()
	var has_child := false
	if dir.open(path) == OK:
		dir.list_dir_begin(true, true)
		while true:
			var node := dir.get_next()
			if node == "":
				break
			var file_path := path.plus_file(node)
			if dir.current_is_dir():
				var item := tree.create_item(par)
				if _update_list_recr(file_path, tree, item):
					has_child = true
					item.set_text(0, node)
					item.set_icon(0, _get_editor_icon("Folder"))
				else:
					item.free()
			else:
				var parts := file_path.split(".")
				if parts.size() > 2 && parts[-2] == "gmap":
					has_child = true
					var item := tree.create_item(par)
					item.set_text(0, node.get_basename().get_basename())
					item.set_icon(0, _get_editor_icon("AtlasTexture"))
					item.set_metadata(0, file_path)
	return has_child


func _get_editor_icon(name: String) -> Texture:
	return editor_interface.get_base_control().get_icon(name, "EditorIcons")


func _on_menu_file_pressed(id: int) -> void:
	match id:
		0:
			update_list()


func _on_tree_actived() -> void:
	var item := tree.get_selected()
	var path = item.get_metadata(0)
	if path is String:
		var res := ResourceLoader.load(path)
		if res is GameMap:
			editor_interface.edit_resource(res)
	else:
		item.collapsed = not item.collapsed
