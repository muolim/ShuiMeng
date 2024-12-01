extends 障碍物

# 横向速度
var horizontal_speed = randf_range(20, 50)

# 初始方向
var direction = 1  # 1 表示向右，-1 表示向左

func _physics_process(delta: float) -> void:
	# 更新横向位置
	global_position.x += horizontal_speed * direction * delta
	
	# 检查是否碰到墙壁
	if global_position.x <= left_wall_x or global_position.x >= right_wall_x:
		direction *= -1  # 反向
	
	# 调用父类的 _physics_process 函数
	super._physics_process(delta)

func _ready() -> void:
	super._ready()
	direction = random_1_or_minus1()

func random_1_or_minus1() -> int:
	return 1 if randf() < 0.5 else -1
