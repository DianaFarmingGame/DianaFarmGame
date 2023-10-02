tool
extends Control


var db: TileDB


func load_db(pdb: TileDB) -> void:
	db = pdb


func _ready() -> void:
	$"%MenuBar".set_menus({
		"文件": [
			[GMenuButton.EntryType.ITEM, "新建文件"],
			[GMenuButton.EntryType.ITEM, "打开文件..."],
		],
		"编辑": [
			[GMenuButton.EntryType.ITEM, "撤销"],
			[GMenuButton.EntryType.ITEM, "重做"],
		],
	})
