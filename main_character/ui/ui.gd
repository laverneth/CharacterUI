extends ParallaxBackground

var selected_spell=""
var life = 4

func _ready():
	get_node("Life").set_frame(4-life )
	set_process(true)

func _process(delta):
	pass

func _read(var text):
	get_node("TextPanel")._read_text(text)
	get_node("TextPanel").set_exclusive(true)
	get_node("TextPanel").popup()
	get_tree().set_pause(true)
	
func _talk(var text):
	get_node("TextPanel")._talk_text(text)
	get_node("TextPanel").set_exclusive(true)
	get_node("TextPanel").popup()
	get_tree().set_pause(true)

func update_life(var life):
	get_node("Life").set_frame(4-life)

