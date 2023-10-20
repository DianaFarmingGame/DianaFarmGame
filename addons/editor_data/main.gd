@tool
extends Control


var editor_interface: EditorInterface
var dbs: Array


@onready var tabs := $"%TabBar" as TabContainer


func _ready():
	tabs.connect("tab_changed", Callable(self, "_on_tab_changed"))
	var popup := GMenuPopup.new()
	popup.set_menu([
		GMenu.Item("刷新所有数据", self, "update_list"),
		GMenu.Item("刷新当前数据", self, "update_current"),
	])
	add_child(popup)
	tabs.set_popup(popup)
	update_list()


func update_list():
	dbs = []
	tabs.current_tab = 0
	var children := tabs.get_children()
	children = children.slice(1, children.size())
	for child in children:
		tabs.remove_child(child)
		child.queue_free()
	
	var path := "res://dbs"
	var dir := DirAccess.open(path)
	if dir != null:
		dir.list_dir_begin() # TODOConverter3To4 fill missing arguments https://github.com/godotengine/godot/pull/40547
		while true:
			var node := dir.get_next()
			if node == "":
				break
			var file_path := path.path_join(node)
			if not dir.current_is_dir():
				if file_path.split(".")[-2] == "gdb":
					var res := ResourceLoader.load(file_path, "", ResourceLoader.CACHE_MODE_REPLACE)
					res.take_over_path(file_path)
					if res is GameDB:
						var db := res as GameDB
						var cont := PanelContainer.new()
						var idx := tabs.get_child_count()
						dbs.append(db)
						tabs.add_child(cont, true)
						tabs.set_tab_title(idx, db.get_db_name())
						tabs.set_tab_icon(idx, db.get_icon(editor_interface))


func update_current() -> void:
	var idx := tabs.current_tab
	if idx > 0:
		var tab := tabs.get_child(idx) as PanelContainer
		for child in tab.get_children():
			tab.remove_child(child)
			child.queue_free()
		var db_path := (dbs[idx - 1] as GameDB).resource_path
		var res := ResourceLoader.load(db_path, "", ResourceLoader.CACHE_MODE_REPLACE)
		dbs[idx - 1] = res
		res.take_over_path(db_path)
		_prepare_tab(idx)


func _get_editor_icon(name: String) -> Texture2D:
	return editor_interface.get_base_control().get_icon(name, "EditorIcons")


func _prepare_tab(idx: int) -> void:
	if idx > 0:
		var db := dbs[idx - 1] as GameDB
		var tab := tabs.get_child(idx) as PanelContainer
		if tab.get_child_count() == 0:
			tab.add_child(db.is_ctrl_pressed(editor_interface))


func _on_tab_changed(idx: int) -> void:
	_prepare_tab(idx)
