@tool
extends Control


var db: TileDB
var editor_interface: EditorInterface
var _sel_tag = null

@onready var menu_bar := %MenuBar as GMenuBar
@onready var ExpandListBtn := %BtnExpandList as Button
@onready var EditorView := %EditorView as Control
@onready var TagList := %TagList as ItemList
@onready var TileList := %TileList as ItemList
@onready var NewBtn := %NewBtn as Button
@onready var CloneBtn := %CloneBtn as Button
@onready var SaveBtn := %SaveBtn as Button
@onready var RefreshBtn := %RefreshBtn as Button


func load_db(pdb: TileDB) -> void:
	if db != null:
		db.changed.disconnect(update_db)
	db = pdb
	db.changed.connect(update_db)


func _ready() -> void:
	update_db()
	ExpandListBtn.connect("toggled", Callable(self, "_on_toggle_expand_list"))
	NewBtn.pressed.connect(_on_add_tile)
	CloneBtn.pressed.connect(_on_clone_tile)
	SaveBtn.pressed.connect(func (): db.need_save.emit())
	RefreshBtn.pressed.connect(db.refresh)
	TileList.item_activated.connect(func (idx):
		var index = TileList.get_item_metadata(idx)
		var tile := db.tiles[index]
		_edit_tile(tile))
	TagList.item_activated.connect(func (idx):
		_sel_tag = TagList.get_item_metadata(idx)
		update_tiles())


func update_db() -> void:
	update_tag_list()
	update_tiles()


func update_tag_list() -> void:
	TagList.clear()
	var idx = TagList.item_count
	TagList.add_item("所有")
	TagList.set_item_metadata(idx, null)
	for tag in db.tags:
		idx = TagList.item_count
		TagList.add_item(tag)
		TagList.set_item_metadata(idx, tag)


func update_tiles() -> void:
	TileList.clear()
	for i in db.tiles.size():
		var tile := db.tiles[i]
		if _sel_tag != null:
			if not tile.tags.has(_sel_tag):
				continue
		TileList.add_item(tile.name, tile.get_icon(editor_interface))
		TileList.set_item_metadata(TileList.item_count - 1, i)


func _on_toggle_expand_list(toggled: bool) -> void:
	EditorView.visible = !toggled


func _on_add_tile() -> void:
	var file_name = await GLDialog.prompt(self, "新建Tile", "请输入文件名", "unname")
	if file_name != null:
		var tile := Tile.new()
		ResourceSaver.save(tile, "res://tiles/" + file_name + ".gtile.tres")
		db.refresh()


func _on_clone_tile() -> void:
	var idxs := TileList.get_selected_items()
	if idxs.size() > 0:
		var idx := idxs[0]
		var index = TileList.get_item_metadata(idx)
		var file_name = await GLDialog.prompt(self, "克隆Tile", "请输入文件名", "unname")
		if file_name != null:
			var tile := db.tiles[index].duplicate(true)
			ResourceSaver.save(tile, "res://tiles/" + file_name + ".gtile.tres")
			db.refresh()


func _edit_tile(tile: Tile) -> void:
	editor_interface.edit_resource(tile)
	var control := tile.get_control(editor_interface)
	if EditorView.get_child_count() > 0:
		for child in EditorView.get_children():
			EditorView.remove_child(child)
			child.queue_free()
	EditorView.add_child(control)
