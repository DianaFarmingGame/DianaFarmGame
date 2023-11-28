extends CharacterBody2D

@export var player: Player
@export var speed: int
@export var run_speed: int
@export var hp_max: int: set = hp_max_change
@export var mp_max: int: set = mp_max_change
@export var eat_limit: int
@export var init_money: int

var hp: int : set = hp_change
var mp: int : set = mp_change
var money: int : set = money_change

var is_control: bool = false
var is_follow: bool = false
var is_tired: bool = false
var is_coma: bool = false
# 保持动画不被打断
var stand_animation: bool = false
var eat_times = 0

var screen_size
var follow_player
var skills = SkillTree.new()

enum Player {
	DIANA, TRAVERLER
}

var dialog_head = preload("res://types/common/dialog_head.tscn")

func _ready():
	screen_size = get_viewport_rect().size
	hp = hp_max
	mp = mp_max
	money = init_money
	$animation.play(get_play_animation("stand"))
#	ui.get_node(get_player_status("hp")).value = hp
#	ui.get_node(get_player_status("mp")).value = mp
	# 初始化主控为旅行者,跟随角色为对方
	if player == Player.TRAVERLER:
		# 初始化旅行者
		is_control = true
		follow_player = diana
		$Camera2D.enabled = true
		traveler_connect()
	else:
		# 初始化Diana
		follow_player = traveler
		$Camera2D.enabled = false
		diana_connect()
	switch_status()
	

func _process(delta):
	# 动画未结束不能进行操作
	if stand_animation:
		return
	# 昏倒后不能进行任何操作
	if is_coma:
		return
	# 不是主控对象
	if !is_control:
		if is_follow:
			follow(delta)
		return
	var animation = get_play_animation("stand")
	velocity = Vector2(0,0)
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
		# 精疲力尽不能奔跑
		if Input.is_action_pressed("run") and !is_tired:
			velocity = velocity.normalized() * run_speed
			$animation.play(get_play_animation("run"))
		else:
			velocity = velocity.normalized() * speed
			$animation.play(get_play_animation("walk"))
	else:
		$animation.play(get_play_animation("stand"))
	move_and_slide()

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

# 以下是状态相关
func hp_change(value):
	hp = value
	ui.get_node(get_player_status("hp")).value = hp

func mp_change(value):
	mp = value
	ui.get_node(get_player_status("mp")).value = mp
	if mp < 0 and !is_tired:
		switch_tired(true)
	if mp > 0 and is_tired:
		switch_tired(false)
	if mp < -15 and !is_coma:
		switch_coma(true)
	if mp > -15 and is_coma:
		switch_coma(false)
	print(str(player) + " mp_change " + str(ui.get_node(get_player_status("mp")).value))

func hp_max_change(value):
	hp_max = value
	ui.get_node(get_player_status("hp")).max_value = hp_max

func mp_max_change(value):
	mp_max = value
	ui.get_node(get_player_status("mp")).max_value = mp_max
	print(str(player) + " max_change " + str(ui.get_node(get_player_status("mp")).max_value))

func money_change(value):
	# 金钱两个人共用一份
	if player == Player.TRAVERLER:
		money = value
		ui.get_node("status/money/num").text = str(money)

# 按下任意键后的行为
func _on_space_press():
	var use_item = ui.get_node("ShortcutPackage/ItemSpace").use_item
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
			hp = clamp(hp + item.hp, -100, hp_max)
		if item.mp != 0:
			# 该道具有回复MP能力
			mp = clamp(mp + item.mp, -100, mp_max)
		if item.tool != null:
			# 该道具为可以使用的工具
			item.tool.use()
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
		return "status/diana/" + status;
	else:
		return "status/traveler/" + status;

# 变更主控角色
func change_control_player():
	is_control = !is_control
	$Camera2D.enabled = !$Camera2D.enabled
	switch_status()

# 跟随角色
func follow(delta):
	# 计算角色与目标之间的距离和方向
	var target_vector = (follow_player.global_position - global_position).normalized()
	var distance = follow_player.global_position.distance_to(global_position)
	# 如果角色与目标之间的距离小于某个值，则停止移动
	if distance < 40:
		return
	else:
		# 否则，设置角色的速度，以向目标移动
		velocity = target_vector * speed
		if velocity.x > 0:
			$animation.flip_h = true
		else:
			$animation.flip_h = false
		move_and_slide()

# 使用锄头
func _on_using_hoe():
	_use_tool("hoe")

# 使用斧头
func _on_using_axe():
	_use_tool("axe")

# 使用棍棒
func _on_using_stick():
	_use_tool("stick")

# 使用镐子
func _on_using_pickaxe():
	_use_tool("pickaxe")

# 使用工具
func _use_tool(tool_name: String):
	var mp_consume = skills.get_consume(tool_name)
	if is_control and player == Player.TRAVERLER:
		stand_animation = true
		$animation.play(get_play_animation(tool_name))
		mp = clamp(mp - mp_consume, -100, mp_max)
		skills.improve_skill(tool_name)

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

func switch_status():
	if player == Player.DIANA:
		if is_control:
			ui.get_node("status/diana").show()
		else:
			ui.get_node("status/diana").hide()
	else:
		if is_control:
			ui.get_node("status/traveler").show()
		else:
			ui.get_node("status/traveler").hide()

func switch_tired(flag: bool):
	if flag:
		is_tired = true
		dialog_head = dialog_head.instantiate()
		dialog_head.text = "X"
		dialog_head.position = Vector2(-40,-90)
		add_child(dialog_head)
	else :
		is_tired = false

func switch_coma(flag: bool):
	if flag:
		is_coma = true
		# 双方都晕倒了
		if _get_another_player().is_coma:
			# todo 损失金钱 + 强行睡觉
			pass
		else :
			# todo 播放昏迷动画
			$animation.play(get_play_animation("stand"))
			change_control_player()
			_get_another_player().change_control_player()
	else :
		is_coma = false

func _get_another_player():
	if player == Player.DIANA:
		return traveler
	else:
		return diana

func sleep():
	# todo 移动到床上
	var recover_mp = mp_max
	if is_tired or is_coma:
		recover_mp = recover_mp * 0.5
	mp = clamp(mp + recover_mp, -100, mp_max)
	
