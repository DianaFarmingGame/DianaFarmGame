extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	const START_TIME = "2022-03-07 00:00:00"
	var time = Time.get_unix_time_from_datetime_string(START_TIME)
	print(time)
	var ts = Time.get_datetime_dict_from_unix_time(time)
	print(ts)
