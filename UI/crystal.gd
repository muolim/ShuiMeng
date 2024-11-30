# 类名
class_name Crystal

extends Control

# 初始化水晶数0
@export var current_crystal:int

@onready var label: Label = $Label

func _on_player_update_crystal() -> void:
	# 更新显示当前水晶数的UI
	label.text=str(current_crystal)
