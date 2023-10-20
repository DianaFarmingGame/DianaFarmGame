@tool
extends Control


@onready var AddMaskSet := %AddMaskSet as Button
@onready var MaskSetPopup := %MaskSetPopup as Window


func _ready() -> void:
	AddMaskSet.pressed.connect(_on_add_mask_set)


func _on_add_mask_set() -> void:
	var result = await MaskSetPopup.open({"mask_size": Vector3(2, 3, 1)})
	print(result)

