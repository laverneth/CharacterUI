extends Area2D

var girl_body = null
var girl_class = preload("res://main_character/lady.gd")
var sign_panel_shown=false

export var text="Castle of Carmaaaaaaaaarghhh"

func _ready():
	get_node("here sign").set_self_opacity(0.0)

func _on_Read_body_enter( body ):
	if( body extends girl_class):
		girl_body=body
		if(sign_panel_shown==false):
			get_node("anim").play("fade_in")
			sign_panel_shown=true

func _on_Read_body_exit( body ):
	if( body extends girl_class):
		if(sign_panel_shown==true):
			sign_panel_shown=false
			get_node("anim").play("fade_out")
		girl_body = null

func _on_Button_pressed():
	var text_array = [text]
	if(girl_body != null):
		girl_body.get_node("ui")._read(text_array)
		get_node("Label").set_self_opacity(0.0)
		get_node("here sign").set_self_opacity(0.0)
		sign_panel_shown = false
		girl_body = null 
