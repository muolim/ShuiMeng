extends Label

# 因为玩家的高度是保持不变的，而tilemap是不断上升的，所以借用tilemap的位置来表示玩家所处的高度
@onready var tile_map_layer: TileMapLayer = $"../../TileMapLayer"

# 偏移值
var offset_value :int=4000

func _physics_process(delta: float) -> void:
	# godot中y轴以上为负值，tilemap初始位置y值为-2000，逐渐增大，将其加4000使初始位置为2000，并随着玩家降落逐渐减小
	var height = tile_map_layer.global_position.y + offset_value
	# 显示在UI中
	text="高度: " + str(int(height)) + " 米"
