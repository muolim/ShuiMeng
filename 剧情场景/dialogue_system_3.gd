extends Control

@export var title:RichTextLabel
@export var content:RichTextLabel
@export var interface:PanelContainer
@export var p1:Sprite2D
@export var p2:Sprite2D


var head_3:Array[int]=[2,1,2,2,1]
var sentences_3:Array[String]=["我们始终是要下地狱的，为那些被害死的人赎罪。",
"战争贯彻人类历史，这是人性的罪果。",
"人至耄耋，才想透人生就是一场无止境的坠落，堕向欲望与纷争。",
"当回忆来袭，谁也逃不过它的鞭笞与嘲弄。","晚安"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interface.show()
	proceed()
	
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("继续"):
	
		if sentences_3.is_empty():
			get_tree().change_scene_to_file("res://UI/start_screen.tscn")
		else:
			proceed()


func _on_button_button_up(event: InputEvent) -> void:
	_input(event)

func proceed():
	var message
	if head_3.pop_front() == 1:
		title.text = "医生"
	else:
		title.text = "患者"
	message = sentences_3.pop_front()
	content.text = message
	if message =="晚安":
		p2.hide()
		p1.hide()
