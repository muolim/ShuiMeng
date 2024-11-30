extends Control

@export var title:RichTextLabel
@export var content:RichTextLabel
@export var interface:PanelContainer
@export var p1:Sprite2D
@export var p2:Sprite2D


var head_2:Array[int]=[1,2,2,1,1,2,2,1,1]
var sentences_2:Array[String]=["你知道那不是你的错，在危急关头谁又能保持理智？",
"唉...但那不是我脱罪的借口。",
"我们亲如兄弟...那次堕落的，不只有是飞机和尸体。",
"...",
"你家人近况如何？",
"孩子们都已成家，过上了自己的生活...咳咳",
"他们偶尔来看看，一如战争中的家书，是我不多的念想了。",
"家庭永远是守护我们的港湾，正如您曾守护他们。",
"...祝你无梦"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interface.show()
	proceed()
	
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("继续"):
	
		if sentences_2.is_empty():
			get_tree().change_scene_to_file("res://剧情场景/dialogue_system_3.tscn")
		else:
			proceed()


func _on_button_button_up(event: InputEvent) -> void:
	_input(event)

func proceed():
	var message
	if head_2.pop_front() == 1:
		title.text = "医生"
	else:
		title.text = "患者"
	message = sentences_2.pop_front()
	content.text = message
	if message == "家庭永远是守护我们的港湾，正如您曾守护他们。":
		p2.hide()
