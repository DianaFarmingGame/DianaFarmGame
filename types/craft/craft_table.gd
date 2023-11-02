extends Resource

class_name CraftTable

var formulas = {}

func get_craft_result(input: String):
	print(input)
	if input in formulas:
		return formulas[input]
	else:
		return null
