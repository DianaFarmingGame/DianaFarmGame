extends Node

class_name Pickaxe

signal using_pickaxe

func use():
	emit_signal("using_pickaxe")
