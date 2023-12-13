extends Control

var item_name: String : set = name_change
var type: String : set = type_change
var describe: String : set = describe_change


func name_change(value):
	item_name = value
	$name.text = value
	
func type_change(value):
	type = value
	$type.text = value
	
func describe_change(value):
	item_name = value
	$describe.text = value
