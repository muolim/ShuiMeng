extends Control

@export var title:RichTextLabel
@export var content:RichTextLabel
@export var interface:PanelContainer
@export var p1:Sprite2D
@export var p2:Sprite2D


var head_1:Array[int]=[1,2,2,1,2,1,1,1]
var sentences_1:Array[String]=["又做梦了吗？还是老样子？",
"嗯，还是老样子。",
"当年侥幸从战场生还，但终究无法释怀，毕竟...",
"我看你拿到了滑翔翼大赛奖章，我很高兴你在积极地回应梦境。",
"二战前我就梦想着飞翔，虽在战争中折翼，但梦想始终未曾变过。我年纪大了，但宝刀未...咳咳！咳！",
"嗯，将安神药服下，多注意休息。",
"我走了，祝你好梦",
"...祝你一夜无梦"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interface.show()
	proceed()
	
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("继续"):
	
		if sentences_1.is_empty():
			get_tree().change_scene_to_file("res://剧情场景/dialogue_system_2.tscn")
		else:
			proceed()


func _on_button_button_up(event: InputEvent) -> void:
	_input(event)

func proceed():
	var message
	if head_1.pop_front() == 1:
		title.text = "医生"
	else:
		title.text = "患者"
	message = sentences_1.pop_front()
	content.text = message
	if message == "嗯，将安神药服下，多注意休息。":
		p2.hide()
	elif message =="晚安":
		p2.hide()
		p1.hide()
