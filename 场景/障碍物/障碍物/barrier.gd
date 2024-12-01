extends StaticBody2D

# 初速度 (米/秒)
@export var initial_velocity = Vector2(0, -100)  # 向上的初速度，负值表示向上

# 加速度 (米/秒²)
@export var acceleration = Vector2(0, -1)  # 向上的加速度，负值表示向上

# 当前速度
var velocity = initial_velocity

# 基础速度
var base_speed = 50

# 当前高度
var current_height = 4000  # 初始高度为4000米

# 偏移值
var offset_value = 4000

# 每坠落100米增加的速度
var speed_increase_per_100m = 5

# 每坠落200米增加的速度（当速度达到80后）
var speed_increase_per_200m = 5

# 高度降到0之后，不再增加速度
var max_speed = 80

func _ready() -> void:
	# 初始化当前高度
	current_height = offset_value

func _physics_process(delta: float) -> void:
	# 更新速度
	velocity += acceleration * delta
	
	# 更新物体的位置
	position += velocity * delta
	
	# 更新当前高度
	current_height -= int(velocity.y * delta)
	
	# 根据高度变化调整速度
	if current_height > 0:
		if base_speed < max_speed:
			# 每坠落100米增加5
			if int(current_height) % 100 == 0:
				base_speed += speed_increase_per_100m
		else:
			# 每坠落200米增加5
			if int(current_height) % 200 == 0:
				base_speed += speed_increase_per_200m
	else:
		# 高度降到0之后，不再增加速度
		base_speed = max_speed
	
	# 更新速度
	velocity.y = -base_speed
