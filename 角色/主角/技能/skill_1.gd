extends Sprite2D

@export var shield:Node2D
var skill_1_time_cd:float = 10
var skill_1_effect:float = 2

func _physics_process(delta: float) -> void:
	skill_1_effect -= delta
	if skill_1_effect <= 0:
		shield.queue_free()
		print("技能1进入cd")
