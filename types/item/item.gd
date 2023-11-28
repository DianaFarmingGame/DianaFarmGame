extends Resource

class_name Item

var name: String
var hp: int
var mp: int
#是否为消耗品（使用后消失）
var consumable: bool = true
#是否为工具
var tool: Node
#是否为盲盒
var blind_box: Node
#是否为食物（受进食次数影响）
var is_food: bool
#耐久度上限
var durability_limit: int
#耐久度
var durability: int
#耐久度为零是否被摧毁
var is_zero_durability_be_destroy: bool

#展示相关

#在背包中展示的图标
var texture: Texture2D
#在世界中展示的图标
var world_texture: Texture2D

func _init(name: String, hp: int, mp: int, consumable: bool, texture: Texture2D,
 		world_texture: Texture2D, tool: Node, blind_box: Node, is_food: bool, durability_limit: int,
		durability: int, is_zero_durability_be_destroy: bool):
	self.name = name
	self.hp = hp
	self.mp = mp
	self.consumable = consumable
	self.texture = texture
	self.world_texture = world_texture
	self.tool = tool
	self.blind_box = blind_box
	self.is_food = is_food
	self.durability_limit = durability_limit
	self.durability = durability
	self.is_zero_durability_be_destroy = is_zero_durability_be_destroy
	
