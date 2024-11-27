extends TileMapLayer

# 初速度 (米/秒)
@export var initial_velocity = Vector2(0, -10)  # 向上的初速度，负值表示向上

# 加速度 (米/秒²)
@export var acceleration = Vector2(0, -1)  # 向上的加速度，负值表示向上

# 当前速度
var velocity = initial_velocity

# 每一帧的更新
func _physics_process(delta: float) -> void:
	# 更新速度
	velocity += acceleration * delta
	
	# 更新物体的位置
	position += velocity * delta
