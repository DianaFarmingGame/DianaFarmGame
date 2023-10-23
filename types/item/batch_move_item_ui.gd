extends Panel

var item: Item: set = set_item
var num: int: set = set_num

signal check(value)

func set_item(value):
	item = value
	$Texcture.texture = value.texture
	$Name.text = value.name

func set_num(value):
	num = value
	$Num.value = value
	$Num.max_value = value
	

func _on_Button_pressed():
	print(num)
	emit_signal("check", num)
	self.queue_free()

func _on_num_value_changed(value):
	num = value
