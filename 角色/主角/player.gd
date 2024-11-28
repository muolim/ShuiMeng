class_name Player

extends CharacterBody2D

# 玩家方向
enum Direction {
	LEFT = -1,
	RIGHT = +1
}

signal hurt
signal get_crystal

@export var direction:=Direction.RIGHT:
	set(v):
		direction = v
		if not is_node_ready():
			await ready
		sprite_2d.scale.x=direction
		
@export var XSPEED : float = 100.0
@export var YSPEED : float = 0.0

@export var camera2D : Camera2D
var cameraShakeNoise: FastNoiseLite

# 右上角,梦核水晶飘向UI的位置
var target_position = Vector2(364, -1970)

@export var player:CharacterBody2D
# 技能1 依次为绑定预制体盾，是否可用技能，cd时间
var skill_scene_1 = preload("res://角色/主角/技能/skill_1.tscn")
var skill_1_is_usable:bool = true
var skill_1_time_cd:float = 10

# 技能2 依次为绑定预制体雷，是否可用技能，cd时间
var skill_scene_2 = preload("res://角色/主角/技能/skill_2.tscn")
var skill_2_is_usable:bool = true
var skill_2_time_cd:float = 5


func _ready():
	#print(str(global_position))
	cameraShakeNoise=FastNoiseLite.new()

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

#func _ready() -> void:
	#canvas_layer.hide()a

func _physics_process(delta: float) -> void:
	var depth = global_position.y
	var movement:=Input.get_axis("向左","向右")
	velocity.x = move_toward(velocity.x, movement * XSPEED, 100)
	velocity.y = YSPEED
		
	if not is_zero_approx(movement):
		# 方向小于0（即-1），翻转
		direction = Direction.RIGHT if movement < 0 else Direction.LEFT
		
	if Input.is_action_just_pressed("技能1") and skill_1_is_usable: #技能1
		skill_1()
	
	if Input.is_action_just_pressed("技能2") and skill_2_is_usable:
		skill_2()
		pass
		
	move_and_slide()

func skill_2():
	print("使用了技能2")
	var grenade =  skill_scene_2.instantiate()
	grenade.position = Vector2(0,0)
	player.add_child(grenade)
	
	skill_2_is_usable = false
	
	var skill_2_timer = Timer.new()                 #添加一个计时器作为cd，结束后设置技能位可用
	player.add_child(skill_2_timer)
	skill_2_timer.one_shot = true
	skill_2_timer.wait_time = skill_2_time_cd
	skill_2_timer.timeout.connect(skill_2_timeout)
	skill_2_timer.start()
func skill_2_timeout():
	print("技能2可以使用")
	skill_2_is_usable = true

func skill_1():
	print("使用了技能1")
	var shield = skill_scene_1.instantiate()          #实例化盾
	shield.position = Vector2(0,0)                  #绑定角色位置后添加
	player.add_child(shield)
	
	skill_1_is_usable = false                       #不可再使用技能
	
	var skill_1_timer = Timer.new()                 #添加一个计时器作为cd，结束后设置技能位可用
	player.add_child(skill_1_timer)
	skill_1_timer.one_shot = true
	skill_1_timer.wait_time = skill_1_time_cd
	skill_1_timer.timeout.connect(skill_1_timeout)
	skill_1_timer.start()
func skill_1_timeout():
	print("技能1可以使用")
	skill_1_is_usable = true
	
func startCameraShake(intensity:float):
	# 屏幕震动噪声乘以强度，改变最后的参数intensity即可改变震动大小
	var cameraOffset=cameraShakeNoise.get_noise_1d(Time.get_ticks_msec()) * intensity
	camera2D.offset.x=cameraOffset
	camera2D.offset.y=cameraOffset

func setShader_BlinkIntensity(newValue:float):
	sprite_2d.material.set_shader_parameter("blink_intensity",newValue)

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("碰到了")
	if body.is_in_group("barrier"):
		print("障碍物")
		
		var blink_tween:Tween = get_tree().create_tween()
		# 角色闪烁从1逐渐降至0
		var camera_tween:Tween = get_tree().create_tween()
		# 屏幕震动强度从5逐渐降至1
		
		#寻找护盾是否存在，存在则销毁护盾，不存在则扣血
		var skill_is_exisx = player.get_node("Skill1") 
		if skill_is_exisx:
			blink_tween.tween_method(setShader_BlinkIntensity,1.0,0.0,1)
			camera_tween.tween_method(startCameraShake,5.0,1.0,0.5)
			print("yes")
			player.remove_child(skill_is_exisx)
		else:
			blink_tween.tween_method(setShader_BlinkIntensity,1.0,0.0,0.2)
			camera_tween.tween_method(startCameraShake,5.0,1.0,0.5)
			emit_signal("hurt")
		
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
		
		# 发出玩家已经得到梦核水晶的信号，接收者是ui的crystal脚本
		emit_signal("get_crystal")
