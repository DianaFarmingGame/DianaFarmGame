extends Node2D

@export var speed: int
@export var run_speed: int
@export var hp_max: int
@export var hp_recover: int

var hp: int : set = hp_change
var mp: int : set = hp_change
var runable: bool = true

var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	hp = hp_max
	$animation.autoplay = "traveler_stand"
	ui.get_node("status/hp").value = hp

func _process(delta):
	if !runable:
		$animation.play("traveler_exhausted")
#		hp = clamp(hp + hp_recover, 0, hp_max)
		if(hp == hp_max):
			runable = true
			$animation.play("traveler_stand")
		return
	var velocity = Vector2.ZERO # The player's movement vector.
	var animation = "traveler_stand"
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		$animation.flip_h = true
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		$animation.flip_h = false
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		if Input.is_action_pressed("run"):
			velocity = velocity.normalized() * run_speed
			hp = clamp(hp - 10, 0, hp_max)
			if hp == 0:
				runable = false
		else:
			velocity = velocity.normalized() * speed
		$animation.play("traveler_walk")
	else:
		hp = clamp(hp + hp_recover, 0, hp_max)
		$animation.play("traveler_stand")
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func _input(event):
	if event.is_action_pressed("universal"):
		_on_space_press()

func hp_change(value):
	hp = value
	ui.get_node("status/hp").value = hp

func mp_change(value):
	mp = value

func _on_space_press():
	var use_item = ui.get_node("ShortcutPackage").use_item
	use(use_item)
			
func use(use_item):
	if use_item != null:
		var item = use_item.item
		if item.hp != null:
			# 该道具有回复HP能力
			hp += item.hp
		if item.mp != null:
			# 该道具有回复MP能力
			mp += item.mp
		if item.consumable:
			use_item.queue_free()
