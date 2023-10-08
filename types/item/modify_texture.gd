extends TextureRect

func _gui_input(event):
	if event is InputEventMouseMotion and event.button_mask & BUTTON_MASK_LEFT:
		if texture:
			var drag_data = texture
			get_viewport().gui_get_drag_data().set_data("image", drag_data)
			set_drag_preview(self)
			texture = null
