tool
class_name GMenuButton extends MenuButton


enum EntryType {
	ITEM
}

var menu: Array
var target: WeakRef

onready var popup := get_popup()


func _ready() -> void:
	popup.connect("id_pressed", self, "_on_id_pressed")


func connect_signals(ptarget: Object) -> void:
	target = weakref(ptarget)


func set_menu(pmenu: Array) -> void:
	print(pmenu)
	popup.clear()
	for entry in pmenu:
		match entry[0]:
			EntryType.ITEM:
				popup.add_item(entry[1])
	menu = pmenu


func _on_id_pressed(idx: int) -> void:
	pass
