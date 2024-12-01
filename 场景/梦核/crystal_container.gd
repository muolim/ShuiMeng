extends Node2D  # 假设容器是一个 Node2D 节点

@onready var player: CharacterBody2D = $"../Player"


# 梦核场景数组
var crystal_scenes : Array  # 存储不同的梦核预制体
var crystal_distance = 200  # 梦核生成的垂直距离 (像素)，这个值不再使用
var crystal_range = 150  # 梦核生成的水平位置范围 (像素)
var crystal_x_min = 50  # 梦核生成的x轴最小值
var crystal_x_max = 330   # 梦核生成的x轴最大值

# 设置梦核生成的固定高度
var fixed_height = 300  # 梦核生成的固定高度 (全局位置 y 坐标)

# 梦核生成间隔控制
var time_between_crystals = randf_range(0.5, 1.5)  # 梦核生成的时间间隔 (秒)
var crystal_timer = 0.0  # 计时器

# 梦核与玩家的最小距离，超过该距离时梦核会被删除
var crystal_lifetime_distance = 800  # 梦核超出此距离后自动删除 (像素)

# 在 ready 函数中加载梦核预制体
func _ready():
	# 加载多个梦核场景
	crystal_scenes.append(preload("res://场景/梦核/crystal.tscn"))
	crystal_scenes.append(preload("res://场景/梦核/crystals.tscn"))
	# 你可以根据需要添加更多梦核预制体

func _physics_process(delta: float) -> void:
	# 计时器控制梦核生成
	crystal_timer -= delta
	if crystal_timer <= 0:
		generate_crystal()
		crystal_timer = time_between_crystals  # 重置计时器

	# 删除超出范围的梦核
	remove_out_of_range_crystals()

# 随机生成梦核
func generate_crystal():
	# 生成梦核的固定高度
	var spawn_position = Vector2(0, fixed_height)
	
	# 随机选择梦核的水平位置 (在给定的固定范围内生成梦核)
	var random_offset = randf_range(crystal_x_min, crystal_x_max)
	spawn_position.x += random_offset
	
	# 随机选择一个梦核场景
	var random_crystal_scene = crystal_scenes[randi() % crystal_scenes.size()]
	
	# 实例化梦核
	var crystal_instance = random_crystal_scene.instantiate() 
	crystal_instance.global_position = spawn_position  # 使用全局位置
	
	# 将梦核添加为容器的子节点
	add_child(crystal_instance)

# 删除超出范围的梦核
func remove_out_of_range_crystals():
	for crystal in get_children():
		if crystal is Node2D:
			# 计算玩家与梦核之间的距离（使用全局位置）
			var distance_to_player = player.global_position.distance_to(crystal.global_position)
			# 如果梦核与玩家的距离超过最大范围，则删除梦核
			if distance_to_player > crystal_lifetime_distance:
				crystal.queue_free()  # 标记该梦核在下一帧被删除
