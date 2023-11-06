extends Node

class_name Axe

signal using_axe

func use():
	emit_signal("using_axe")
