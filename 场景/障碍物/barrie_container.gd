extends Node2D  # 假设容器是一个 Node2D 节点

@onready var player: CharacterBody2D = $"../Player"

# 障碍物场景数组
var obstacle_scenes : Array  # 存储不同的障碍物预制体
var obstacle_distance = 200  # 障碍物生成的垂直距离 (像素)
var obstacle_range = 150  # 障碍物生成的水平位置范围 (像素)
var obstacle_x_min = 50  # 障碍物生成的x轴最小值
var obstacle_x_max = 330   # 障碍物生成的x轴最大值

# 墙壁位置
var left_wall_x = 48  # 左侧墙壁的 x 坐标
var right_wall_x = 336  # 右侧墙壁的 x 坐标

# 指定生成障碍物的高度（即垂直位置）
var obstacle_height = 300  # 障碍物生成的固定高度

# 障碍物生成间隔控制
var time_between_obstacles = randf_range(0.5, 1.5) # 障碍物生成的时间间隔 (秒)
var obstacle_timer = 0.0  # 计时器
# 障碍物与玩家的最小距离，超过该距离时障碍物会被删除
var obstacle_lifetime_distance = 800  # 障碍物超出此距离后自动删除 (像素)

# 在 ready 函数中加载障碍物预制体
func _ready():
	# 加载多个障碍物场景
	#obstacle_scenes.append(preload("res://场景/障碍物/障碍物预制体/barrier_1.tscn"))
	obstacle_scenes.append(preload("res://场景/障碍物/障碍物/barrier.tscn"))
	obstacle_scenes.append(preload("res://场景/障碍物/障碍物/barrier (2).tscn"))
	obstacle_scenes.append(preload("res://场景/障碍物/障碍物/barrier (22).tscn"))
	obstacle_scenes.append(preload("res://场景/障碍物/障碍物/barrier (222).tscn"))
	obstacle_scenes.append(preload("res://场景/障碍物/障碍物/barrier (222222).tscn"))
	obstacle_scenes.append(preload("res://场景/障碍物/障碍物/barrier (2222222).tscn"))

	# 你可以根据需要添加更多障碍物预制体

func _physics_process(delta: float) -> void:
	# 计时器控制障碍物生成
	obstacle_timer -= delta
	if obstacle_timer <= 0:
		generate_obstacle()
		obstacle_timer = time_between_obstacles  # 重置计时器
		
	# 删除超出范围的障碍物
	remove_out_of_range_obstacles()

# 随机生成障碍物
func generate_obstacle():
	# 使用指定的固定高度生成障碍物
	var spawn_position = Vector2(0, obstacle_height)
	
	# 随机选择障碍物的水平位置
	var random_offset = randf_range(obstacle_x_min, obstacle_x_max)
	#spawn_position.x += random_offset

	# 随机选择一个障碍物场景
	var random_obstacle_scene = obstacle_scenes[randi() % obstacle_scenes.size()]
	# 实例化障碍物
	var obstacle_instance = random_obstacle_scene.instantiate() 
	
	# 获取障碍物的宽度，避免与墙壁重叠
	var obstacle_width = 0
	var sprite = obstacle_instance.get_node("Sprite2D")  # 如果使用了 Sprite
	if sprite:
		obstacle_width = sprite.region_rect.size.x - sprite.region_rect.size.y
	else:
		var collision_shape = obstacle_instance.get_node("CollisionShape2D")  # 如果使用了 CollisionShape2D
		if collision_shape:
			var shape = collision_shape.shape
			if shape is RectangleShape2D:
				obstacle_width = shape.extents.x * 2  # 获取矩形的宽度
	
	# 计算生成位置，确保障碍物的宽度完全在墙壁之间
	var min_x_position = left_wall_x + obstacle_width / 2
	var max_x_position = right_wall_x - obstacle_width / 2
	
	# 将生成位置限制在墙壁之间，并考虑障碍物的宽度
	spawn_position.x = clamp(spawn_position.x + random_offset, min_x_position, max_x_position)
	
	obstacle_instance.position = spawn_position
	
	# 将障碍物添加为容器的子节点
	add_child(obstacle_instance)

# 删除超出范围的障碍物
func remove_out_of_range_obstacles():
	for obstacle in get_children():
		if obstacle is Node2D:
			var distance_to_player = player.position.distance_to(obstacle.position)
			# 如果障碍物与玩家的距离超过最大范围，则删除障碍物
			if distance_to_player > obstacle_lifetime_distance:
				obstacle.queue_free()  # 标记该障碍物在下一帧被删除
