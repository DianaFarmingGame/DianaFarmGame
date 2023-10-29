@tool
class_name GAtlasEdit extends Node


signal completed(result)

var Main: Window
var CancelBtn: Button
var OkBtn: Button
var ScrollRoot: Control
var TextureCont: Control
var TextureSprite: Sprite2D
var TextureSelection: Control
var XStep: SpinBox
var XOffset: SpinBox
var YStep: SpinBox
var YOffset: SpinBox
var Zoom: Range

@export var multi_select := false

var sel_range := Rect2():
	set(v):
		sel_range = v
		if sel_range.size.x > 0 and sel_range.size.y > 0:
			TextureSelection.position = sel_range.position
			TextureSelection.size = sel_range.size
			TextureSelection.visible = true
		else:
			TextureSelection.visible = false



func _ready() -> void:
	add_child(preload("./main.tscn").instantiate())
	Main = $Main
	CancelBtn = Main.get_node("%CancelBtn")
	OkBtn = Main.get_node("%OkBtn")
	ScrollRoot = Main.get_node("%ScrollRoot")
	TextureCont = Main.get_node("%TextureCont")
	TextureSprite = Main.get_node("%TextureSprite")
	TextureSelection = Main.get_node("%TextureSelection")
	XStep = Main.get_node("%XStep")
	XOffset = Main.get_node("%XOffset")
	YStep = Main.get_node("%YStep")
	YOffset = Main.get_node("%YOffset")
	Zoom = Main.get_node("%Zoom")
	TextureCont.gui_input.connect(_cont_gui_input)
	Zoom.value_changed.connect(_zoom_change)
	
	OkBtn.pressed.connect(_on_confirm)
	CancelBtn.pressed.connect(_on_cancel)
	Main.close_requested.connect(_on_cancel)


func edit(title: String, texture: Texture2D, prange := Rect2(), cfgs := [8, 0, 8, 0]):
	Main.title = title
	sel_range = prange
	XStep.value = cfgs[0]
	XOffset.value = cfgs[1]
	YStep.value = cfgs[2]
	YOffset.value = cfgs[3]
	Main.popup_centered_clamped()
	_set_texture.call_deferred(texture)
	var result = await completed
	Main.hide()
	return result


func _set_texture(texture: Texture2D) -> void:
	TextureSprite.texture = texture
	_update_view()


func _update_view() -> void:
	var texture_size := TextureSprite.texture.get_size()
	var root := ScrollRoot.get_parent() as Control
	var root_size = root.size
	TextureCont.size = texture_size
	ScrollRoot.custom_minimum_size = root_size + texture_size * TextureCont.scale
	TextureCont.position = root_size / 2


func _zoom_change(zoom: float) -> void:
	var scale := 2 ** zoom
	TextureCont.scale = Vector2(scale, scale)
	_update_view()


var _sel_start_p := Vector2()
var _sel_end_p := Vector2()
func _cont_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouse and event.button_mask & MOUSE_BUTTON_MASK_LEFT) \
	or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT):
		var cell_size := Vector2(XStep.value, YStep.value)
		var size := TextureSprite.texture.get_size()
		var pos := event.position as Vector2
		if multi_select:
			var spos := pos.snapped(cell_size).clamp(Vector2(), size)
			TextureCont.accept_event()
			if event is InputEventMouseButton:
				if event.pressed:
					_sel_start_p = spos
					_sel_end_p = spos
				else:
					_sel_end_p = spos
			if event is InputEventMouseMotion:
				_sel_end_p = spos
		else:
			var vrange := size / cell_size - Vector2(1, 1)
			var index := (pos / cell_size).floor().clamp(Vector2(), vrange)
			if event is InputEventMouseButton && event.pressed:
				TextureCont.accept_event()
				_sel_start_p = index * cell_size
				_sel_end_p = (index + Vector2(1, 1)) * cell_size
		sel_range = Rect2(
				min(_sel_start_p.x, _sel_end_p.x),
				min(_sel_start_p.y, _sel_end_p.y),
				abs(_sel_start_p.x - _sel_end_p.x),
				abs(_sel_start_p.y - _sel_end_p.y),
		)


func _on_confirm() -> void:
	completed.emit(sel_range)


func _on_cancel() -> void:
	completed.emit(null)
