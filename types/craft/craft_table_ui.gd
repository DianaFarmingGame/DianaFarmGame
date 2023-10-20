extends Window

func _input(event):
	if event.is_action_pressed("use_craft_table"):
		popup()
