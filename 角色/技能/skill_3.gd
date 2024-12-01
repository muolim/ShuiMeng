extends Node2D

# 这个是用于监听碰撞的信号
signal collided_with_barrier

# 初速度 (米/秒)
@export var initial_velocity = Vector2(0, 100)  # 向上的初速度，负值表示向上
# 加速度 (米/秒²)
@export var acceleration = Vector2(0, 1)  # 向上的加速度，负值表示向上
@export var world:Node2D
# 当前速度
var velocity = initial_velocity
# 加载爆炸场景
#var boom_scene = preload("res://角色/主角/技能/boom.tscn")


func _physics_process(delta: float) -> void:
	# 更新速度
	velocity += acceleration * delta
	
	# 更新物体的位置
	position += velocity * delta

func _on_item_body_entered(body):
	# 检查是否碰到了 Barrier
	if body.is_in_group("barrier"):
		# 发出信号通知碰撞
		#var boom =  boom_scene.instantiate()  # 实例化手榴弹
		#body.position = boom.position
		#body.add_child(boom)
		print("爆炸！！！！")
		# 销毁道具
		queue_free()
		# 销毁 Barrier
		body.queue_free()


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
