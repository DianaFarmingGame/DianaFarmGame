extends Resource

class_name ItemSpace
const ItemNode = preload("res://types/item/item_node.tscn")

#临时初始化空间中的物品
@export var space_name: String
@export var total_volumn: int
@export var init_types : Array
var items : set = items_set

signal items_changed(indexs)

var used_volumn = 0

#temp
func init():
	var init_items = []
	for type in init_types:
		var item_node = ItemNode.instantiate()
		item_node.item = type
		item_node.num = 1
		init_items.append(item_node)
	while init_items.size() < total_volumn:
		init_items.append(null)
	items_set(init_items)

func items_set(value):
	items = value
	used_volumn = countNonNullObjects(items)

func set_item(index, item):
	#判空
	if item == null:
		items[index] = null
		emit_signal("items_changed",[index])
		used_volumn = countNonNullObjects(items)
		return
	#判断一下该物品在当前空间是否有同列项，有则合并
	for origin_item in items:
		if origin_item != null && origin_item != item && origin_item.get_item_name() == item.get_item_name():
			# 自己不能和自己堆叠,同类物品才能堆叠
			origin_item.num += item.num
			return
	items[index] = item
	emit_signal("items_changed",[index])
	used_volumn = countNonNullObjects(items)

func get_item(index):
	return items[index]

func remove_item(index):
	var current_item = items[index]
	items[index] = null
	emit_signal("items_changed",[index])
	used_volumn = countNonNullObjects(items)
	return current_item

func clear():
	var remove_item_indexs = []
	print(total_volumn)
	for i in range(items.size()):
		if items[i] != null:
			items[i] = null
			remove_item_indexs.append(i)
	used_volumn = 0
	emit_signal("items_changed",remove_item_indexs)

func countNonNullObjects(array):
	var count = 0
	for obj in array:
		if obj != null:
			count += 1
	return count
