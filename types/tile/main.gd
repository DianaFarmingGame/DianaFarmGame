@tool
extends Control


var tile: Tile

@onready var AddMaskSet := %AddMaskSet as Button
@onready var MaskSetPopup := %MaskSetPopup as Window
@onready var SrcImgSelDialog := %SrcImgSelDialog as GFileDialog
@onready var Name := %Name as LineEdit
@onready var Tags := %Tags as LineEdit
@onready var SrcImg := %SrcImg as LineEdit
@onready var SrcImgSelBtn := %SrcImgSelBtn as Button
@onready var Width := %Width as SpinBox
@onready var Height := %Height as SpinBox
@onready var TileWidth := %TileWidth as SpinBox
@onready var TileHeight := %TileHeight as SpinBox
@onready var MaskSizeX := %MaskSizeX as SpinBox
@onready var MaskSizeY := %MaskSizeY as SpinBox
@onready var CheckInfo := %CheckInfo as TextEdit
@onready var Masks := %Masks as VBoxContainer
@onready var SaveBtn := %SaveBtn as Button


func _ready() -> void:
	AddMaskSet.pressed.connect(_on_add_mask_set)
	SrcImgSelBtn.pressed.connect(_on_src_img_sel)
	Name.text_submitted.connect(func (text):
		tile.name = text
		tile.changed.emit()
		refresh())
	Tags.text_submitted.connect(func (text: String):
		tile.tags = Array(text.split(","))
		for i in tile.tags.size():
			tile.tags[i] = tile.tags[i].strip_edges()
		refresh())
	SrcImg.text_submitted.connect(func (text):
		tile.src_img = text
		tile.changed.emit()
		refresh())
	Width.value_changed.connect(func (value):
		tile.block_size.x = value
		tile.changed.emit()
		refresh())
	Height.value_changed.connect(func (value):
		tile.block_size.y = value
		tile.changed.emit()
		refresh())
	TileWidth.value_changed.connect(func (value):
		tile.tile_size.x = value
		tile.changed.emit()
		refresh())
	TileHeight.value_changed.connect(func (value):
		tile.tile_size.y = value
		tile.changed.emit()
		refresh())
	MaskSizeX.value_changed.connect(func (value):
		tile.mask_size.x = value
		tile.changed.emit()
		refresh())
	MaskSizeY.value_changed.connect(func (value):
		tile.mask_size.y = value
		tile.changed.emit()
		refresh())
	SaveBtn.pressed.connect(func ():
		tile.need_save.emit())


func load_db(ptile: Tile) -> void:
	tile = ptile
	refresh.call_deferred()


func refresh() -> void:
	check()
	var img := load(tile.src_img) as Texture2D
	Name.text = tile.name
	SrcImg.text = tile.src_img
	Width.value = tile.block_size.x
	Height.value = tile.block_size.y
	TileWidth.value = tile.tile_size.x
	TileHeight.value = tile.tile_size.y
	MaskSizeX.value = tile.mask_size.x
	MaskSizeY.value = tile.mask_size.y
	for child in Masks.get_children():
		Masks.remove_child(child)
		child.queue_free()
	for index in tile.mask_set.size():
		var cfg := tile.mask_set[index] as TileMaskItem
		var node := preload("./mask_cfg.tscn").instantiate()
		node.load_cfg.call_deferred(index, img, tile.tile_size, cfg)
		Masks.add_child(node)
		node.call_edit.connect(_on_mask_edit)
		node.call_del.connect(_on_mask_delete)


func check() -> void:
	var warn := ""
	if not load(tile.src_img) is Texture2D:
		warn += "无效的源图片\n"
	if not(tile.mask_size.x == 1 or tile.mask_size.x == 3) \
	or not(tile.mask_size.y == 1 or tile.mask_size.y == 3):
		warn += "无效的掩码大小 (仅支持1,3)\n"
	if warn.length() > 0:
		CheckInfo.text = warn.trim_suffix("\n")
		CheckInfo.add_theme_color_override("font_readonly_color", Color.RED)
	else:
		CheckInfo.text = "无问题"
		CheckInfo.remove_theme_color_override("font_readonly_color")


func _on_src_img_sel() -> void:
	var result = await SrcImgSelDialog.select_file("选择图片", ["*.png, *.jpg, *.jpeg ; 支持的图片"])
	if result != null:
		tile.src_img = result
		tile.changed.emit()
		refresh()


func _on_add_mask_set() -> void:
	var img = load(tile.src_img)
	var result = await MaskSetPopup.open({
		"mask_size": tile.mask_size,
		"tile_size": tile.tile_size,
		"src_img": img,
	})
	if result != null:
		var cfg := TileMaskItem.new()
		cfg.size = result.get("mask_size")
		cfg.data = result.get("mask_data")
		cfg.pos = result.get("tile_pos")
		tile.mask_set.push_back(cfg)
		tile.changed.emit()
		refresh()


func _on_mask_edit(idx: int) -> void:
	var img = load(tile.src_img)
	var cfg := tile.mask_set[idx] as TileMaskItem
	var result = await MaskSetPopup.open({
		"mask_size": cfg.size,
		"mask_data": cfg.data,
		"src_img": img,
		"tile_pos": cfg.pos,
		"tile_size": tile.tile_size,
	})
	if result != null:
		cfg.size = result.get("mask_size")
		cfg.data = result.get("mask_data")
		cfg.pos = result.get("tile_pos")
		tile.changed.emit()
		refresh()

func _on_mask_delete(idx: int) -> void:
	tile.mask_set.remove_at(idx)
	tile.changed.emit()
	refresh()
