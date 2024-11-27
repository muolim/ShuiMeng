class_name Player

extends CharacterBody2D

# 玩家方向
enum Direction {
	LEFT = -1,
	RIGHT = +1
}

signal hurt

@export var direction:=Direction.RIGHT:
	set(v):
		direction = v
		if not is_node_ready():
			await ready
		sprite_2d.scale.x=direction
		
@export var XSPEED : float = 200.0
@export var YSPEED : float = 0.0

@export var camera2D : Camera2D
var cameraShakeNoise: FastNoiseLite

func _ready():
	cameraShakeNoise=FastNoiseLite.new()

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

#func _ready() -> void:
	#canvas_layer.hide()

func _physics_process(delta: float) -> void:
	var depth = global_position.y
	var movement:=Input.get_axis("向左","向右")
	velocity.x = move_toward(velocity.x, movement * XSPEED, 100)
	velocity.y = YSPEED
		
	if not is_zero_approx(movement):
		# 方向小于0（即-1），翻转
		direction = Direction.RIGHT if movement < 0 else Direction.LEFT
		
	move_and_slide()

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
		blink_tween.tween_method(setShader_BlinkIntensity,1.0,0.0,0.2)
		
		var camera_tween:Tween = get_tree().create_tween()
		# 屏幕震动强度从5逐渐降至1
		camera_tween.tween_method(startCameraShake,5.0,1.0,0.5)
		
		emit_signal("hurt")
