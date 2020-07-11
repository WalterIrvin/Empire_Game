extends Sprite
export (StreamTexture) var tile_texture
export var id = -1
export var amt = 0
var cur_pos = Vector2(0, 0)
var win_size = OS.get_window_size()
var amt_ref

func _ready():
	Globals.Global_Floating_Ref = self
	amt_ref = get_child(0)
	
func _process(delta):
	if id == -1:
		amt = 0
	if amt == 0:
		id = -1
	if id < 0:
		amt = 0
		tile_texture = null
	else:
		var cur_item = Globals.Global_Item_Dictionary.get_item(id)
		var cur_stex = StreamTexture.new()
		cur_stex.load_path = cur_item.stream_path
		tile_texture = cur_stex
	if amt >= 2:
		amt_ref.text = "x" + str(amt)
	else:
		amt_ref.text = ""
	win_size = OS.get_window_size()
	cur_pos = get_viewport().get_mouse_position()
	#cur_pos.x -= (win_size.x / 2.0)
	#cur_pos.y -= (win_size.y / 2.0)
	position = cur_pos
	texture = tile_texture
