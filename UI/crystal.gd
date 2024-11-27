extends HBoxContainer

# 初始化水晶数0
@export var current_crystal:int=0

@onready var label: Label = $Label

func update_crystal(value):
	# 梦核水晶加1并更新显示
	current_crystal += 1
	label.text=str(current_crystal)

# 收到玩家得到水晶的信号后，更新水晶数
func _on_player_get_crystal() -> void:
	update_crystal(current_crystal)
	pass # Replace with function body.
