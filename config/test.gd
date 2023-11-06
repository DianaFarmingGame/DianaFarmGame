extends Control

signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	hit.connect(b.bind())
	a()
#	var hoe = ToolSet.Hoe.new()
#	# 创建新的 ConfigFile 对象。
#	var config = ConfigFile.new()
#	# 存储一些值。
#	var texture = load("res://asset/20231003-140403.jpeg")
#	var item = Item.new("email",10,10,true,texture,texture,hoe)
#	config.set_value(item.name, "hp", item.hp)
#	config.set_value(item.name, "mp", item.mp)
#	config.set_value(item.name, "consumable", item.consumable)
#	config.set_value(item.name, "texture", item.texture)
#	config.set_value(item.name, "world_texture", item.world_texture)
#	config.set_value(item.name, "tool", item.tool)
#
#	# 将其保存到文件中（如果已存在则覆盖）。
#	config.save("res://config/test.cfg")

func a():
	emit_signal("hit")

func b():
	print("111")
