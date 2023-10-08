extends Panel

var is_visible: bool

func _ready():
	hide()
	is_visible = false

func _input(event):
	if event.is_action_pressed("use_craft_table"):
		if is_visible:
			hide()
			is_visible = false
		else:
			show()
			is_visible = true
	
