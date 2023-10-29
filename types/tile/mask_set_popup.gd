@tool
extends Window


signal resolve(result)

@onready var BitMask := %BitMask as GBitMask
@onready var TileBtn := %TileBtn as Button
@onready var CanelBtn := %CanelBtn as Button
@onready var ConfirmBtn := %ConfirmBtn as Button
@onready var TileDialog := %TileDialog as GAtlasEdit
@onready var TilePreview := %TilePreview as TextureRect

var _tile_size: Vector2


func _ready() -> void:
	close_requested.connect(_on_cancel)
	TileBtn.pressed.connect(_on_select_tile)
	CanelBtn.pressed.connect(_on_cancel)
	ConfirmBtn.pressed.connect(_on_confirm)


func init(data = {}) -> void:
	BitMask.init(
			data.get("mask_size"),
			data.get("mask_data", null),
	)
	_tile_size = data.get("tile_size", Vector2(8, 8))
	var texture := TilePreview.texture as AtlasTexture
	var dpos = data.get("tile_pos")
	if dpos != null:
		texture.region = Rect2(dpos * _tile_size, _tile_size)
	else:
		texture.region = Rect2()
	texture.atlas = data.get("src_img", null)


func open(data = {}) -> Variant:
	init(data)
	popup_centered_clamped()
	var result = await resolve
	hide()
	return result


func _on_select_tile() -> void:
	var result = await TileDialog.edit("选择绘制区域", TilePreview.texture.atlas, TilePreview.texture.region, [_tile_size.x, 0, _tile_size.y, 0])
	if result != null and result.size == _tile_size:
		TilePreview.texture.region = result


func _on_cancel() -> void:
	resolve.emit(null)


func _on_confirm() -> void:
	var result := {
		"mask_size": BitMask.mask_len,
		"mask_data": BitMask.mask,
		"tile_pos": TilePreview.texture.region.position / _tile_size,
	}
	resolve.emit(result)
