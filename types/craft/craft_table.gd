extends Resource

class_name CraftTable

var lark = preload("res://dbs/item/lark.tres")

var formulas = {
	"email+weixing" : [lark]
}

func get_craft_result(input: String):
	print(input)
	if input in formulas:
		return formulas[input]
	else:
		return null
