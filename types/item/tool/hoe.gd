extends Node

class_name Hoe

signal using_hoe

func use():
	emit_signal("using_hoe")
