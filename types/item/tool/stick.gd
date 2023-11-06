extends Node

class_name Stick

signal using_stick

func use():
	emit_signal("using_stick")
