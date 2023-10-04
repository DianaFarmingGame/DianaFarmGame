tool
extends Control


var db: TileDB

onready var menu_bar := $"%MenuBar" as MenuBar


func load_db(pdb: TileDB) -> void:
	db = pdb


func _ready() -> void:
	menu_bar.set_menus({
		"文件": [
			GMenuButton.Item("新建文件", self, "_on_create_file", ["hello.txt"]),
			GMenuButton.Item("打开文件..."),
			GMenuButton.Separator(),
			GMenuButton.Item("关闭"),
		],
		"编辑": [
			GMenuButton.Item("撤销"),
			GMenuButton.Item("重做"),
		],
	})


func _on_create_file(test_arg: String) -> void:
	print("create file: ", test_arg)
