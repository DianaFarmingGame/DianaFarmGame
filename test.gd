extends Node2D

@onready var package = $CanvasLayer/package
@onready var status = $CanvasLayer/status
@onready var shortcut = $CanvasLayer/shortcut

var data = [
		{
			"picture":load("res://asset/ui/斧头.png"),
			"num":1
		},
		{
			"picture":load("res://asset/ui/斧头.png"),
			"num":2
		},
		{
			"picture":load("res://asset/ui/斧头.png"),
			"num":3
		},null,null,null,null,null,null
		,null,null,null,null,null,null
		,null,null,null,null,null
	]
	
var shortcut_data = [
		{
			"picture":load("res://asset/ui/铲子.png"),
			"num":1
		},
		{
			"picture":load("res://asset/ui/铲子.png"),
			"num":2
		},
		{
			"picture":load("res://asset/ui/铲子.png"),
			"num":3
		},null,null,null,null,null,null,null
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	package.connect("move_item", Callable(self, "_on_item_move"))
	package.connect("remove_item", Callable(self, "_on_item_remove"))
	package.connect("use_item", Callable(self, "_on_item_used"))
	package.draw_space(data)
	shortcut.draw_space(shortcut_data)
	status.set_traveler_hp_max(100)
	status.set_traveler_hp(100)
	status.set_traveler_mp_max(200)
	status.set_traveler_mp(200)
	status.set_diana_hp_max(80)
	status.set_diana_hp(80)
	status.set_diana_mp_max(150)
	status.set_diana_mp(150)
	status.show_traveler()
	status.set_money(114514)

func _input(event):
	if event.is_action_pressed("switch_player"):
		status.show_diana()
		print(status.get_time())

func _on_item_move(from_space, from_index, to_space, to_index):
	var temp = data[to_index]
	data[to_index] = data[from_index]
	data[from_index] = temp
	package.draw_space(data)

func _on_item_remove(from_space, from_index):
	data[from_index] = null
	package.draw_space(data)

func _on_item_used(from_space, from_index):
	print(from_index)
