extends HBoxContainer

var heart=preload("res://素材/heart.png")
var empty_heart=preload("res://素材/empty_heart.png")
# 两种血量显示方式
enum TYPES {type1,type2}
@export var type := TYPES.type1

#func _ready() -> void:
	#for i in self.get_child_count():
		#if max_heart>i:
			#get_child(i).show()
		#else:
			#get_child(i).hide()

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
		#if i > max_heart:
			#get_child(i).hide()
		#else:
			#get_child(i).show()
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
