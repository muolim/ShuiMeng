class_name main

extends Control

@onready var label: Label = $Label
@onready var heart: HBoxContainer = $Heart

# 当前血量
static var max_heart:int=3
static var current_heart:int

func _ready():
	# 初始化血量为最大血量
	current_heart = max_heart
	for i in heart.get_child_count():
		if max_heart>i:
			heart.get_child(i).show()
		else:
			heart.get_child(i).hide()
	update_heart_num()

# 更新血量值，和heart.gd中的update_heart()有点像，但不是一个
func update_heart_num():
	# 更新血量值时改变显示
	label.text = "HP:" + str(current_heart)
	heart.update_heart(current_heart)

func _on_button_pressed() -> void:
	# 按钮1血量减1，并更新血量值
	if 0 >= current_heart - 1:
		# 血量小于等于0时重新加载场景
		get_tree().reload_current_scene()
	else:
		current_heart -= 1
		update_heart_num()

func _on_button_2_pressed() -> void:
	# 按钮2血量加1，并更新血量值
	if max_heart < current_heart + 1:
		pass
	else:
		current_heart += 1
		update_heart_num()
