extends Resource

class_name Item

var name: String
var hp: int
var mp: int
#是否为消耗品（使用后消失）
var consumable: bool = true

#展示相关

#在背包中展示的图标
var texture: Texture2D
#在世界中展示的图标
var world_texture: Texture2D

func _init(name: String, hp: int, mp: int, consumable: bool, texture: Texture2D, world_texture: Texture2D):
	self.name = name
	self.hp = hp
	self.mp = mp
	self.consumable = consumable
	self.texture = texture
	self.world_texture = world_texture
	
	
