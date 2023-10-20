@tool
class_name GBitMask extends Control


const base_size := 56.0
const margin := 6.0
const gap := 2.0

var mask_len: Vector3
var mask: Array


func _init() -> void:
	init()


func init(lens := Vector3(3, 3, 1), pmask = null) -> void:
	mask_len = lens
	if pmask != null:
		mask = pmask
	else:
		mask = Array()
		mask.resize(int(mask_len.x * mask_len.y * mask_len.z))
		mask.fill(false)
	queue_redraw()


func _get_minimum_size() -> Vector2:
	if mask_len.z == 1:
		return Vector2(base_size, base_size)
	else:
		# FIXME
		return Vector2()


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var xw := (base_size - margin * 2 - gap * (mask_len.x - 1)) / mask_len.x
		var yw := (base_size - margin * 2 - gap * (mask_len.y - 1)) / mask_len.y
		var mevent := event as InputEventMouseButton
		var x := mevent.position.x
		var y := mevent.position.y
		var ix := int((x - margin) / (gap + xw))
		var iy := int((y - margin) / (gap + yw))
		var in_box := x - margin - ix * (gap + xw) <= xw and y - margin - iy * (gap + yw) <= yw
		if in_box:
			mask[mask_len.x * iy + ix] = not mask[mask_len.x * iy + ix]
			queue_redraw()
			accept_event()


func _draw() -> void:
	var xw := (base_size - margin * 2 - gap * (mask_len.x - 1)) / mask_len.x
	var yw := (base_size - margin * 2 - gap * (mask_len.y - 1)) / mask_len.y
	var cx := margin
	for ix in mask_len.x:
		var cy := margin
		for iy in mask_len.y:
			if mask[mask_len.x * iy + ix]:
				draw_rect(Rect2(cx, cy, xw, yw), Color(0xffffffff), true)
			else:
				draw_rect(Rect2(cx, cy, xw, yw), Color(0xffffff22), true)
			cy += yw + gap
		cx += xw + gap
