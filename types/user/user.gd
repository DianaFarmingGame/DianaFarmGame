extends Node2D

@export var speed: int
@export var run_speed: int
@export var hp_max: int
@export var hp_recover: int
@export var mp_max: int
@export var player: Player
@export var eat_limit: int

var hp: int : set = hp_change
var mp: int : set = mp_change

var runable: bool = true
var is_control: bool = false
var is_follow: bool = false
# 保持动画不被打断
var stand_animation: bool = false
var eat_times = 0

var screen_size
var follow_player

enum Player {
	DIANA, TRAVERLER
}

func _ready():
	screen_size = get_viewport_rect().size
	hp = hp_max
	mp = mp_max
	$animation.play(get_play_animation("stand"))
	ui.get_node(get_player_status("hp")).value = hp
	ui.get_node(get_player_status("mp")).value = mp
	# 初始化主控为旅行者,跟随角色为对方
	if player == Player.TRAVERLER:
		# 初始化旅行者
		is_control = true
		follow_player = diana
		traveler_connect()
	else:
		# 初始化Diana
		follow_player = traveler
		diana_connect()
	

func _process(delta):
	# 不是主控对象
	if !is_control:
		if is_follow:
			follow(delta)
		return
	# 动画未结束不能进行操作
	if stand_animation:
		return
	if !runable:
		$animation.play(get_play_animation("exhausted"))
#		hp = clamp(hp + hp_recover, 0, hp_max)
		if(hp == hp_max):
			runable = true
			$animation.play(get_play_animation("stand"))
		return
	var velocity = Vector2.ZERO # The player's movement vector.
	var animation = get_play_animation("stand")
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
		$animation.play(get_play_animation("walk"))
	else:
		hp = clamp(hp + hp_recover, 0, hp_max)
		$animation.play(get_play_animation("stand"))
		
	position += velocity * delta
#	position = position.clamp(Vector2.ZERO, screen_size)

func _input(event):
	# 动画未结束不能进行操作
	if stand_animation:
		return
	if event.is_action_pressed("switch_player"):
		change_control_player()
	if event.is_action_pressed("meet"):
		is_follow = !is_follow
	if !is_control:
		return
	#此后的部分非主控角色不触发
	if event.is_action_pressed("universal"):
		_on_space_press()

func hp_change(value):
	if value != hp:
		hp = value
		ui.get_node(get_player_status("hp")).value = hp

func mp_change(value):
	if value != mp:
		mp = value
		ui.get_node(get_player_status("mp")).value = mp

# 按下任意键后的行为
func _on_space_press():
	var use_item = ui.get_node("ShortcutPackage").use_item
	use(use_item)
			
func use(use_item):
	if use_item != null:
		var item = use_item.item
		if item.is_food == true:
			#食物受食用上限影响
			if eat_times >= eat_limit:
				return
			eat_times += 1
		if item.hp != 0:
			# 该道具有回复HP能力
			hp = clamp(hp + item.hp, 0, hp_max)
		if item.mp != 0:
			# 该道具有回复MP能力
			mp = clamp(mp + item.mp, 0, mp_max)
		if item.tool != null:
			# 该道具为可以使用的工具
			item.tool.use()
			mp -= 10
		if item.blind_box != null:
			# 该道具为盲盒
			var gifts = item.blind_box.open()
			for gift in gifts:
				ui.get_node("Package").get_node("ItemSpace").add_item(gift)
		if item.consumable:
			# 该道具为消耗品
			if use_item.num > 1:
				use_item.num -= 1
			else:
				use_item.queue_free()

# 根据当前角色获取动画名称
func get_play_animation(animation: String) -> String:
	if player == Player.DIANA:
		return "diana_" + animation;
	else:
		return "traveler_" + animation;

# 根据当前角色获取状态名称
func get_player_status(status: String) -> String:
	if player == Player.DIANA:
		return "status/diana_" + status;
	else:
		return "status/traveler_" + status;

# 变更主控角色
func change_control_player():
	is_control = !is_control

# 跟随角色
func follow(delta):
	# 计算角色与目标之间的距离和方向
	var velocity = Vector2.ZERO
	var target_vector = (follow_player.global_position - global_position).normalized()
	var distance = follow_player.global_position.distance_to(global_position)
	# 如果角色与目标之间的距离小于某个值，则停止移动
	if distance < 10:
		return
	else:
		# 否则，设置角色的速度，以向目标移动
		velocity = target_vector * speed
		# todo 碰撞体处理
#		$CharacterBody2D.velocity = velocity
#		$CharacterBody2D.move_and_slide()
		if velocity.x > 0:
			$animation.flip_h = true
		else:
			$animation.flip_h = false
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)

# 使用锄头
func _on_using_hoe():
	if is_control and player == Player.TRAVERLER:
		stand_animation = true
		$animation.play(get_play_animation("hoeing"))

# 使用斧头
func _on_using_axe():
	if is_control and player == Player.TRAVERLER:
		stand_animation = true
		$animation.play(get_play_animation("chop"))

# 使用棍棒
func _on_using_stick():
	if is_control and player == Player.TRAVERLER:
		stand_animation = true
		$animation.play(get_play_animation("stick"))

# 使用镐子
func _on_using_pickaxe():
	if is_control and player == Player.TRAVERLER:
		stand_animation = true
		$animation.play(get_play_animation("tap"))

# 订阅Diana的信号
func diana_connect():
	pass
	
# 订阅旅行者的信号
func traveler_connect():
	# 几种工具的触发
	ToolSet.tools.get("hoe").using_hoe.connect(_on_using_hoe.bind())
	ToolSet.tools.get("axe").using_axe.connect(_on_using_axe.bind())
	ToolSet.tools.get("stick").using_stick.connect(_on_using_stick.bind())
	ToolSet.tools.get("pickaxe").using_pickaxe.connect(_on_using_pickaxe.bind())

func _on_animation_animation_looped():
	stand_animation = false
