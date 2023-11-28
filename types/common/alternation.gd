extends CanvasModulate

class_name Alternation

enum DayTime {
	NORMAL, SUNRISE, SUNSET
}

const DAY_COLOR = Color("ffffff")
const NIGHT_COLOR = Color("202020")

@export var factor: float
var status: DayTime

# Called when the node enters the scene tree for the first time.
func _ready():
	self.color = NIGHT_COLOR
	status = DayTime.NORMAL

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var value = factor * delta
	if status == DayTime.SUNRISE:
		self.color = color.lerp(DAY_COLOR, value)
	elif status == DayTime.SUNSET:
		self.color = color.lerp(NIGHT_COLOR, value)
