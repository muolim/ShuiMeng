#extends CharacterBody2D
#
#@export var XSPEED : float = 0.0
#@export var YSPEED : float = -100.0
#
#@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
#@onready var sprite_2d: Sprite2D = $Sprite2D
#
#func _physics_process(delta: float) -> void:
	#velocity.y = YSPEED
#
	#move_and_slide()
extends StaticBody2D

# 初速度 (米/秒)
@export var initial_velocity = Vector2(0, -100)  # 向上的初速度，负值表示向上

# 加速度 (米/秒²)
@export var acceleration = Vector2(0, -1)  # 向上的加速度，负值表示向上

# 当前速度
var velocity = initial_velocity

func _ready() -> void:
	#print(str(global_position))
	pass

# 每一帧的更新
func _physics_process(delta: float) -> void:
	# 更新速度
	velocity += acceleration * delta
	
	# 更新物体的位置
	position += velocity * delta
