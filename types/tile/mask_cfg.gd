@tool
extends HBoxContainer


signal call_edit(idx)
signal call_del(idx)

var index: int

@onready var BitMask := %BitMask as GBitMask
@onready var NTexture := %Texture as TextureRect
@onready var Edit := %Edit as Button
@onready var Delete := %Delete as Button


func _ready() -> void:
	Edit.pressed.connect(func ():
		call_edit.emit(index))
	Delete.pressed.connect(func ():
		call_del.emit(index))


func load_cfg(pindex: int, img: Texture2D, tsize: Vector2, cfg: TileMaskItem) -> void:
	index = pindex
	BitMask.init(cfg.size, cfg.data)
	BitMask.editable = false
	NTexture.texture.atlas = img
	NTexture.texture.region = Rect2(cfg.pos * tsize, tsize)
