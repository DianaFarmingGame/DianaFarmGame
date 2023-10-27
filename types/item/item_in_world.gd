extends Node2D

const ItemNode = preload("res://types/item/item_node.tscn")

@export var item: Item
var num = 1
var can_collect = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$animation.play(item.name)
	$Label.text = item.name
	$Label.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_collect && Input.is_action_pressed("universal"):
		var item_instance = gen_item_instance()
		$"../ui/Package/ItemSpace".add_item(item_instance)
		self.queue_free()
		

func _on_area_2d_body_entered(body):
	if body.get_parent().name == "traveler":
		can_collect = true
		$Label.show()


func _on_area_2d_body_exited(body):
	if body.get_parent().name == "traveler":
		can_collect = false
		$Label.hide()

func gen_item_instance():
	var item_instance = ItemNode.instantiate()
	item_instance.item = self.item
	item_instance.num = self.num
	return item_instance
