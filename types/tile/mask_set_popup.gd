@tool
extends Window


signal resolve(result)

@onready var BitMask := %BitMask as GBitMask
@onready var TileBtn := %TileBtn as Button
@onready var CanelBtn := %CanelBtn as Button
@onready var ConfirmBtn := %ConfirmBtn as Button


func _ready() -> void:
	close_requested.connect(_on_cancel)
	CanelBtn.pressed.connect(_on_cancel)
	ConfirmBtn.pressed.connect(_on_confirm)


func init(data = {}) -> void:
	BitMask.init(
			data.get("mask_size"),
			data.get("mask_data", null),
	)


func open(data = {}) -> Variant:
	init(data)
	popup_centered_clamped()
	var result = await resolve
	hide()
	return result


func _on_cancel() -> void:
	resolve.emit(null)


func _on_confirm() -> void:
	var result := {
		"mask_size": BitMask.mask_len,
		"mask_data": BitMask.mask,
	}
	resolve.emit(result)
