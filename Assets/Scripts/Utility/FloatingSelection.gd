extends Sprite
export (StreamTexture) var tile_texture
export var res_type = "none"
export var res_amt = 0
export var tool_quality = 0
export var tool_type = "none"
var cur_pos = Vector2(0, 0)
var win_size = OS.get_window_size()
var amt_ref

func _ready():
	amt_ref = get_child(0)
	
func _process(delta):
	if res_amt >= 2:
		amt_ref.text = "x" + str(res_amt)
	else:
		amt_ref.text = ""
	win_size = OS.get_window_size()
	cur_pos = get_viewport().get_mouse_position()
	#cur_pos.x -= (win_size.x / 2.0)
	#cur_pos.y -= (win_size.y / 2.0)
	position = cur_pos
	texture = tile_texture
