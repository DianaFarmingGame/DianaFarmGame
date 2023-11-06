extends Control

static func load_config(path: String, fields: Array):
	var data = {}
	var config = ConfigFile.new()
	# 从文件加载数据。
	var err = config.load(path)
	# 如果文件没有加载，忽略它。
	if err != OK:
		return data
	for item in config.get_sections():
		# 获取每个小节的数据。
		data[item] = {}
		for field in fields:
			data[item][field] = config.get_value(item, field)
	return data

static func save_config():
	# 创建新的 ConfigFile 对象。
	var config = ConfigFile.new()
	# 存储一些值。
	var texture = load("res://asset/20231003-140403.jpeg")
	var item = Item.new("email",10,10,true,texture,texture,null,null)
	config.set_value(item.name, "hp", item.hp)
	config.set_value(item.name, "mp", item.mp)
	config.set_value(item.name, "consumable", item.consumable)
	config.set_value(item.name, "texture", item.texture)
	config.set_value(item.name, "world_texture", item.world_texture)

	# 将其保存到文件中（如果已存在则覆盖）。
	config.save("res://config/item.cfg")
