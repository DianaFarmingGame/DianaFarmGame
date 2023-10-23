extends Resource

class_name ItemDictionary

var item_dictionary = {
	"lark": preload("res://dbs/item/lark.tres"),
	"email": preload("res://dbs/item/email.tres")
}

func add_item(item: Item):
	if item is Item:
		item_dictionary[item.name] = item

func get_item(name: String):
	return item_dictionary[name]

func get_all_item():
	return item_dictionary.values()

func edit_item(name: String, item: Item):
	item_dictionary.erase(name)
	add_item(item)
