extends PopupPanel

var text=""

var text_size=-1
var text_pos=0

func _ready():
	# Initalization here
	get_node("anim").play("glow")
	pass

func _talk_text(var given_text):
	text = given_text
	if(text.empty() == false):
		text_size = text.size()
		text_pos = 0
		get_node("Text").hide()
		get_node("Text").set_text(text[text_pos])
		get_node("anim").play("typewriter")

func _read_text(var given_text):
	text = given_text
	if(text.empty() == false):
		text_size = text.size()
		text_pos = 0
		get_node("Text").set_text(text[text_pos])
		get_node("Text").set_percent_visible(1.0)
		get_node("anim").play("write")

func hide_current_panel():
	set_exclusive(false)
	get_tree().set_pause(false)
	hide()

func _on_Button_pressed():
	text_pos = text_pos+1
	if(text_pos == text_size):
		hide_current_panel()
	else:
		get_node("Text").hide()
		get_node("Text").set_text(text[text_pos])
		get_node("anim").play("typewriter")
