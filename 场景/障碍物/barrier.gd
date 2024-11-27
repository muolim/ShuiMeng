extends CharacterBody2D

@export var XSPEED : float = 0.0
@export var YSPEED : float = -50.0

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	velocity.y = YSPEED

	move_and_slide()
