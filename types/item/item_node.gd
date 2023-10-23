extends TextureRect

var item: Item: set = set_item
var num: int: set = set_num

const ItemBatchMove = preload("res://types/item/batch_move_item_ui.tscn")

func set_item(value):
	item = value
	$".".texture = value.texture
	$Name.text = value.name

func set_num(value):
	num = value
	$Num.text = str(value)
	
func get_item_name():
	return item.name

func _get_drag_data(_position):
	var item_index = get_parent().get_index()
	var space = get_parent().get_parent().space
	var data = {
			"item": self,
			"item_index": item_index,
			"space": space
		}
	var drag_preview = TextureRect.new()
	drag_preview.texture = texture
	set_drag_preview(drag_preview)
	return data
		
func _ready():
	$Name.hide()

func _on_TextureRect_mouse_entered():
	$Name.show()

func _on_TextureRect_mouse_exited():
	$Name.hide()
