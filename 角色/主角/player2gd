class_name Player

extends CharacterBody2D

# 玩家方向
enum Direction {
	
	LEFT = -1,
	RIGHT = +1
}

signal hurt
signal update_crystal

@export var direction:=Direction.RIGHT:
	set(v):
		direction = v
		if not is_node_ready():
			await ready
		sprite_2d.scale.x = direction * 0.1
		
@export var XSPEED : float = 100.0
@export var YSPEED : float = 0.0

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var camera2D : Camera2D
var cameraShakeNoise: FastNoiseLite

# 右上角,梦核水晶飘向UI的位置
var target_position = Vector2(366, -1985)


@export var player:CharacterBody2D
@export var world:Node2D
# 梦核水晶类，需要一个Crystal类对象，即class_name为Crystal的对象，即ui/crystal脚本
@export var crystal:Crystal

# 技能1 依次为绑定预制体盾，是否可用技能，cd时间
@export var skill_1_ui:TextureRect # 绑定上技能1的UI节点，显示技能状态
var skill_scene_1 = preload("res://角色/主角/技能/skill_1.tscn")
var skill_1_is_usable:bool = true
var skill_1_time_cd:float = 10.0 
var skill_1_crystal_required:int = 3 # 技能需求梦核水晶数量（策划案中为20）
var skill_1_wudi:bool=false # 护盾生效期间碰到障碍物便进入无敌状态

# 技能3 依次为绑定预制体雷，是否可用技能，cd时间
@export var skill_2_ui:TextureRect # 绑定上技能2的UI节点，显示技能状态
var skill_scene_3 = preload("res://角色/主角/技能/skill_3.tscn")
var skill_3_is_usable:bool = true
var skill_3_time_cd:float = 5.0
var skill_3_crystal_required:int = 3 # 技能需求梦核水晶数量（策划案中为10）

# 技能5 
@export var skill_3_ui:TextureRect # 绑定上技能3的UI节点，显示技能状态
var skill_5_is_using = false                                # 技能5是否在使用
var skill_5_last_fall_position_y                            # 存储使用技能5后要返回y轴的位置
var skill_5_mouse_position:Vector2                          # 鼠标位置
var skill_5_x_fall_speed = 30 * XSPEED                      # 初始左右移动速度
var skill_5_y_fall_speed = -150                             # 初始向下移动速度
var skill_5_y_back_speed = -100                             # 初始返回速度
var mouse_position_x = get_global_mouse_position().x        # 初始化鼠标位置的x轴
var is_go_back = false                                      # 判断是否处于返回阶段
var skill_5_is_usable:bool = true                           # 技能5是否可用
var skill_5_time_cd:float = 1                               # 技能5cd时间
var skill_5_last_speed = Vector2(0,0)                       # 保存移动后的速度，防止碰撞导致速度变为0

func _ready():
	cameraShakeNoise=FastNoiseLite.new()
	skill_5_last_fall_position_y = player.position.y        # 初始化存储位置为当前位置

func _physics_process(delta: float) -> void:
	var depth = global_position.y
	
	# 更改能进行左右移动条件，必须没有使用技能5 且 不处于技能5的返回状态
	if !skill_5_is_using and !is_go_back:
		move()
	
	# 如果按下技能1，并且技能1可用（冷却完毕），并且当前梦核水晶数大于等于技能1消耗的水晶数
	if Input.is_action_just_pressed("技能1") and skill_1_is_usable and crystal.current_crystal >= skill_1_crystal_required:
		skill_1(delta)
	
	if Input.is_action_just_pressed("技能3") and skill_3_is_usable and crystal.current_crystal >= skill_3_crystal_required:
		skill_3()
	
	if Input.is_action_just_pressed("技能5") and skill_5_is_usable:  
		skill_5_fall()
		
	
	# 循环判断（条件为 是否到达 且 在使用技能5）是否到达位置，到达后速度归零
	if abs(mouse_position_x - player.position.x) <= 1 and skill_5_is_using:
			skill_5_is_using=false
			velocity = Vector2.ZERO
	# 松开左键 确定技能5使用完毕，开始返回初始位置
	if Input.is_action_just_released("技能5"):
		skill_5_back()
	# 循环判断（条件为 是否到达 且 在返回状态）是否返回到达
	if player.position.y-skill_5_last_fall_position_y <=0 and is_go_back:
		print("返回到达且技能5进入cd")
		velocity = Vector2.ZERO 
		is_go_back = false
		var skill_5_timer = Timer.new()                 #添加一个计时器作为cd，结束后设置技能位可用
		player.add_child(skill_5_timer)
		skill_5_timer.one_shot = true
		skill_5_timer.wait_time = skill_5_time_cd
		skill_5_timer.timeout.connect(skill_5_timeout)
		skill_5_timer.start()
	if skill_5_last_speed!=velocity and skill_5_is_using:
		print("遭遇碰撞，恢复速度，恢复前：",velocity,"恢复后：",skill_5_last_speed)
		velocity = skill_5_last_speed
		
	move_and_slide()

func skill_5_fall():
	print("使用技能5")
		# 确定使用技能5，并且存储使用了技能5时的位置
	skill_5_is_using = true  
	skill_5_is_usable = false                              
	skill_5_last_fall_position_y = player.position.y
		# 获取目标点x轴坐标
	skill_5_mouse_position = get_global_mouse_position()
	mouse_position_x = skill_5_mouse_position.x
		# 赋予速度，并实现
	var direction = skill_5_mouse_position - player.position
	var move_vector = direction.normalized() * Vector2(skill_5_x_fall_speed,skill_5_y_fall_speed)
	skill_5_last_speed=move_vector
	velocity = move_vector
	print("保存下滑速度：",skill_5_last_speed,"：",velocity)
	
func skill_5_back():
	print("技能5返回中")
	skill_5_is_using = false
	is_go_back = true
	velocity.y = skill_5_y_back_speed
	velocity.x = 0
	
func skill_5_timeout():
	print("技能5可以使用")
	skill_5_is_usable = true

func skill_3():
	print("使用了技能3")
	# 在这里修改Crystal中的current_crystal，减去了释放3技能消耗的水晶量
	crystal.current_crystal -= skill_3_crystal_required
	# 发出更新水晶信号
	emit_signal("update_crystal")
	var grenade =  skill_scene_3.instantiate()  # 实例化手榴弹
	grenade.position = player.position
	world.add_child(grenade)
	
	skill_3_is_usable = false
	
	var skill_3_timer = Timer.new()                 #添加一个计时器作为cd，结束后设置技能位可用
	player.add_child(skill_3_timer)
	skill_3_timer.one_shot = true
	skill_3_timer.wait_time = skill_3_time_cd
	skill_3_timer.timeout.connect(skill_3_timeout)
	skill_3_timer.start()
	
func skill_3_timeout():
	print("技能3可以使用")
	skill_3_is_usable = true
	

func skill_1(delta):
	print("使用了技能1")
	# 在这里修改Crystal中的current_crystal，减去了释放1技能消耗的水晶量
	crystal.current_crystal -= skill_1_crystal_required
	# 发出更新水晶信号
	emit_signal("update_crystal")
	var shield = skill_scene_1.instantiate()          #实例化盾
	shield.position = Vector2(0,0)                  #绑定角色位置后添加
	player.add_child(shield)
	
	skill_1_is_usable = false                       #不可再使用技能
	
	var skill_1_timer = Timer.new()                 #添加一个计时器作为cd，结束后设置技能为可用
	player.add_child(skill_1_timer)
	skill_1_timer.one_shot = true
	skill_1_timer.wait_time = skill_1_time_cd
	skill_1_timer.timeout.connect(skill_1_timeout)
	skill_1_timer.start()
	
func skill_1_timeout():
	print("技能1可以使用")
	skill_1_is_usable = true
	
func move():
	var movement:=Input.get_axis("向左","向右")
	velocity.x = move_toward(velocity.x, movement * XSPEED, 100)
	velocity.y = YSPEED
	if not is_zero_approx(movement):
			# 方向小于0（即-1），翻转
			direction = Direction.RIGHT if movement < 0 else Direction.LEFT
	
# 屏幕震动
func startCameraShake(intensity:float):
	# 屏幕震动噪声乘以强度，改变最后的参数intensity即可改变震动大小
	var cameraOffset=cameraShakeNoise.get_noise_1d(Time.get_ticks_msec()) * intensity
	camera2D.offset.x=cameraOffset
	camera2D.offset.y=cameraOffset

# 玩家闪烁
func setShader_BlinkIntensity(newValue:float):
	sprite_2d.material.set_shader_parameter("blink_intensity",newValue)

# 玩家无敌的颜色
func setShader_InvincibilityColor(a:Color):
	sprite_2d.material.set_shader_parameter("invincibility_color",Color(a))
	
# 玩家无敌的透明度
func setShader_InvincibilityIntensity(newValue:float):
	sprite_2d.material.set_shader_parameter("invincibility_intensity",newValue)

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("碰到了")
	if body.is_in_group("barrier"):
		print("障碍物")
		
		var blink_tween:Tween = get_tree().create_tween()
		var invincibility_color_tween:Tween = get_tree().create_tween()
		var invincibility_intensity_tween:Tween = get_tree().create_tween()
		var camera_tween:Tween = get_tree().create_tween()
		
		#if skill_1_effect>0:
		# 寻找护盾是否存在，存在则销毁护盾，不存在则扣血
		var skill_is_exist = player.get_node("Skill1") 
		if skill_is_exist:
			skill_1_wudi = true
			print("进入无敌时间")
			var skill_wudi_timer = Timer.new()
			player.add_child(skill_wudi_timer)
			skill_wudi_timer.one_shot = true
			# 无敌持续的时长
			skill_wudi_timer.wait_time = 2
			skill_wudi_timer.timeout.connect(skill_wudi_timeout)
			skill_wudi_timer.start()
			
			# 使玩家颜色变化，可以调整下面这4个invincibility_color_tween中的Color参数实现不同的颜色变化
			# 无敌时长共2秒，故每个tween时长0.5秒，依次执行，共2秒
			invincibility_color_tween.tween_method(setShader_InvincibilityColor,Color(1,0,1,1),Color(0,1,0,1),0.5)
			invincibility_color_tween.tween_method(setShader_InvincibilityColor,Color(0,1,0,1),Color(1,0,1,1),0.5)
			invincibility_color_tween.tween_method(setShader_InvincibilityColor,Color(1,0,1,1),Color(0,1,0,1),0.5)
			invincibility_color_tween.tween_method(setShader_InvincibilityColor,Color(0,1,0,1),Color(1,0,1,1),0.5)

			# 玩家透明度变化
			invincibility_intensity_tween.tween_method(setShader_InvincibilityIntensity,1.0,1.0,2)
			invincibility_intensity_tween.tween_method(setShader_InvincibilityIntensity,1.0,0.0,0)

			camera_tween.tween_method(startCameraShake,5.0,1.0,0.5)
			print("yes")
			player.remove_child(skill_is_exist)
		elif skill_1_wudi:
			pass
		else:
			# 角色闪烁从1逐渐降至0
			blink_tween.tween_method(setShader_BlinkIntensity,1.0,0.0,1)
			# 屏幕震动强度从5逐渐降至1
			camera_tween.tween_method(startCameraShake,5.0,1.0,0.5)
			# 发送受伤信号
			emit_signal("hurt")
		
func skill_wudi_timeout():
	print("退出无敌时间")
	skill_1_wudi = false
	
# 碰到梦核水晶，则给ui的crystal脚本发送得到梦核的信号
func _on_area_2d_area_entered(area: Area2D) -> void:
	print("碰到了")
	if area.is_in_group("crystal"):
		print("梦核水晶")
		
		# 创建一个Tween节点来控制水晶飘向UI的动画
		var tween = get_tree().create_tween()
		# 获取收集品的位置
		var start_position = area.global_position
		# 将收集品移动到右上角UI位置
		tween.tween_property(area, "global_position", target_position, 0.5)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_LINEAR)
		# 释放水晶节点
		tween.tween_callback(area.queue_free)
		crystal.current_crystal += 1
		
		# 发出玩家已经得到梦核水晶的信号，接收者是ui的crystal脚本
		emit_signal("update_crystal")
		
		
	if area.is_in_group("crystals"):
		print("梦核水晶")
		
		# 创建一个Tween节点来控制水晶飘向UI的动画
		var tween = get_tree().create_tween()
		# 获取收集品的位置
		var start_position = area.global_position
		# 将收集品移动到右上角UI位置
		tween.tween_property(area, "global_position", target_position, 0.5)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_LINEAR)
		# 释放水晶节点
		tween.tween_callback(area.queue_free)
		crystal.current_crystal += 4
		
		# 发出玩家已经得到梦核水晶的信号，接收者是ui的crystal脚本
		emit_signal("update_crystal")
