class_name GameMap extends Resource


@export var name: String


var map_height: int
var map_size: Vector2


# 初始化数据
func _init_data() -> void:
	pass


# 获取地图所使用的渲染节点
func _get_render_node() -> Node2D:
	return Node2D.new()


# 初始化渲染节点
func _init_render_node(_node: Node2D) -> void:
	pass


# 用当前的数据更新渲染节点
func _update_render_node(_node: Node2D) -> void:
	pass


# 设置对应层的可见性
func _set_layer_visible(_node: Node2D, _visible: bool) -> void:
	pass


# 计算点和层的相交结果
func _raycast_point_layer(_node: Node2D, _point: Vector2, _layer: int) -> Vector2:
	return Vector2()


# 计算点和整个地图的相交结果
func _raycast_point_map(_node: Node2D, _point: Vector2) -> Vector3:
	return Vector3()


# 设置某个点对应的Tile
func _set_tile(_layer: int, _point: Vector2, _tile_id: int) -> void:
	pass
