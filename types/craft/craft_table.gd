extends Resource

class_name CraftTable

var email = preload("res://dbs/item/email.tres")

var formulas = {
	"lark+weixing" : [email]
}

func get_craft_result(input: String):
	if input in formulas:
		return formulas[input]
	else:
		return null
