tool
extends Control


var editor_interface: EditorInterface
var dbs: Array


onready var tabs := $"%Tabs" as TabContainer


func _ready():
	tabs.connect("tab_changed", self, "_on_tab_changed")
	update_list()


func update_list():
	dbs = []
	var children := tabs.get_children()
	children = children.slice(1, children.size())
	for child in children:
		tabs.remove_child(child)
		child.queue_free()
	
	var path := "res://dbs"
	var dir := Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin(true, true)
		while true:
			var node := dir.get_next()
			if node == "":
				break
			var file_path := path.plus_file(node)
			if not dir.current_is_dir():
				if file_path.split(".")[-2] == "gdb":
					var res := ResourceLoader.load(file_path)
					if res is GameDB:
						var db := res as GameDB
						var cont := PanelContainer.new()
						var idx := tabs.get_child_count()
						dbs.append(db)
						tabs.add_child(cont, true)
						tabs.set_tab_title(idx, db.get_name())
						tabs.set_tab_icon(idx, db.get_icon(editor_interface))


func _get_editor_icon(name: String) -> Texture:
	return editor_interface.get_base_control().get_icon(name, "EditorIcons")


func _on_tab_changed(idx: int) -> void:
	if idx > 0:
		var db := dbs[idx - 1] as GameDB
		var tab := tabs.get_child(idx) as PanelContainer
		if tab.get_child_count() == 0:
			tab.add_child(db.get_control(editor_interface))
