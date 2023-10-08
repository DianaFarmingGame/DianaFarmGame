extends TextureRect

func get_drag_data(_position):
	var item_index = get_parent().get_index()
	var space = get_parent().get_parent().space
	var item = space.get_item(item_index)
	if item is Item:
		var data = {
			"item": item,
			"item_index": item_index,
			"space": space
		}
		var drag_preview = TextureRect.new()
		drag_preview.texture = texture
		set_drag_preview(drag_preview)
		return data
		
func _ready():
	$Label.hide()

func _on_TextureRect_mouse_entered():
	$Label.show()

func _on_TextureRect_mouse_exited():
	$Label.hide()
