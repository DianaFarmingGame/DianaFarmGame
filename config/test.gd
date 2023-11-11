extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	# 创建新的 ConfigFile 对象。
	var config = ConfigFile.new()
	# 存储一些值。
	var a = {
		"hoe": 1,
		"email": 2,
	}
	config.set_value("aaa", "inputs", a)
	var b = 1
	config.set_value("aaa", "b", b)
	# 将其保存到文件中（如果已存在则覆盖）。
	config.save("res://config/test.cfg")
	print('111')
