extends Area2D
var entered = false
var exited=false
var girl_body = null
var girl_class = preload("res://peoples/girl/girl.gd")
var has_talk=false
var never_fade_in=true
var talk_invite_shown=false
var state=0

func _ready():
	get_node("Sprite").set_self_opacity(0.0)

func _on_Talk_body_enter( body ):
	if( body extends girl_class):
		girl_body=body
		if(has_talk==false and talk_invite_shown==false):
			get_node("anim").play("fade_in")
			talk_invite_shown=true
	entered = true


func _on_Talk_body_exit( body ):
	exited = true
	if( body extends girl_class):
		if(talk_invite_shown==true):
			talk_invite_shown=false
			get_node("anim").play("fade_out")
		girl_body = null

func _on_Button_pressed():
	if(girl_body != null):
		get_node("Sprite").set_self_opacity(0.0)
		get_node("Label").set_self_opacity(0.0)
		girl_body.get_node("ui")._talk(get_parent().text)
		#get_node("anim").play("fade_out")
