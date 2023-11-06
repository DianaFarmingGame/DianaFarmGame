extends Node

const Hoe = preload("res://types/item/tool/hoe.gd")
const Axe = preload("res://types/item/tool/axe.gd")
const Stick = preload("res://types/item/tool/stick.gd")
const Pickaxe = preload("res://types/item/tool/pickaxe.gd")

var tools = {
	"hoe" : Hoe.new(),
	"axe" : Axe.new(),
	"stick" : Stick.new(),
	"pickaxe" : Pickaxe.new(),
}
