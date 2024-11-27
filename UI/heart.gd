extends HBoxContainer

var heart=preload("res://素材/美术/heart.png")
var empty_heart=preload("res://素材/美术/empty_heart.png")
# 两种血量显示方式
enum TYPES {type1,type2}
@export var type := TYPES.type1

# 最大血量
var max_heart:int=3
# 当前血量
var current_heart:int

func _ready():
	# 初始化血量为最大血量
	current_heart = max_heart
	for i in self.get_child_count():
		if max_heart>i:
			self.get_child(i).show()
		else:
			self.get_child(i).hide()
	update_heart(current_heart)

# 更新血量
func update_heart(value):
	match type:
		TYPES.type1:
			update_type1(value)
		TYPES.type2:
			update_type2(value)
	
# 第一种血量显示方式，只显示满心
func update_type1(value):
	for i in self.get_child_count():
		if i < value:
			get_child(i).show()
		else:
			get_child(i).hide()
	
# 第二种血量显示方式，失去血量则用空心代替
func update_type2(value):
	for i in self.get_child_count():
		if i < value:
			get_child(i).texture = heart
		else:
			get_child(i).texture = empty_heart

func _on_player_hurt() -> void:
	# 按钮1血量减1，并更新血量值
	if 0 >= current_heart - 1:
		# 血量小于等于0时重新加载场景
		get_tree().reload_current_scene()
	else:
		current_heart -= 1
		update_heart(current_heart)
