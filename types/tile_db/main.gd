tool
extends Control


var db: TileDB

onready var menu_bar := $"%MenuBar" as MenuBar
onready var tag_list := $"%TagList" as ItemList


func load_db(pdb: TileDB) -> void:
	db = pdb


func _ready() -> void:
	menu_bar.set_menus({
		"数据": [
			GMenuButton.Item("添加标签", self, "_on_add_tag"),
		],
	})
	update_db()


func update_db() -> void:
	update_tag_list()


func update_tag_list() -> void:
	tag_list.clear()
	var idx = tag_list.get_item_count()
	tag_list.add_item("所有")
	tag_list.set_item_metadata(idx, null)
	for tag in db.tags:
		idx = tag_list.get_item_count()
		tag_list.add_item(tag)
		tag_list.set_item_metadata(idx, tag)


func _on_add_tag() -> void:
	var dialog := GLDialog.prompt("添加标签", "请输入标签的名称：", "", "标签名称")
	add_child(dialog)
	dialog.open()
	var result = yield(dialog, "resolved")
	remove_child(dialog)
	dialog.queue_free()
	if result:
		db.add_tag(result)
	update_db()
