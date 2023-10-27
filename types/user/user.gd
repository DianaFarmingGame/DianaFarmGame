extends Node2D

@export var speed: int
@export var run_speed: int
@export var hp_max: int
@export var hp_recover: int

var hp: int : set = hp_change
var runable: bool = true

var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	hp = hp_max
	$animation.autoplay = "traveler"
	$"../ui/status/hp".value = hp

func _process(delta):
	if !runable:
		$animation.play("traveler_exhausted")
		hp = clamp(hp + hp_recover, 0, hp_max);
		if(hp == hp_max):
			runable = true
			$animation.play("traveler")
		return
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		if Input.is_action_pressed("run"):
			velocity = velocity.normalized() * run_speed
			hp = clamp(hp - 10, 0, hp_max);
			if hp == 0:
				runable = false
		else:
			velocity = velocity.normalized() * speed
		$animation.play("traveler")
	else:
		hp = clamp(hp + hp_recover, 0, hp_max);
		$animation.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func hp_change(value):
	hp = value
	$"../ui/status/hp".value = value
