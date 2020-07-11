extends Area2D

export (StreamTexture) var tile_texture
export var id = 0  # the id to pull from the global dictionary
export var res_yield = 0  # base yield for the node
export var min_quality = 0  # base value for mine level
export var effective_tool = 0 # cur values: 0:axe, 1:pick, 2:shovel
var interaction = false  # player within interaction range
var interest = false  # player mouse hovering over node
var progress_bar
var sprite_ref
var base_mine_time = 1
var timer
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	timer = base_mine_time
	progress_bar = find_node("Mining_Progress")
	sprite_ref = find_node("Mineable_Sprite")
	sprite_ref.texture = tile_texture


func _process(delta):
	if not interaction:
		progress_bar.hide()
	else:
		var amt_left = timer / base_mine_time
		progress_bar.value = amt_left * 100
		progress_bar.show()
		if Input.is_action_pressed("mine") and timer >= 0 and interest:
			var mining_speed = delta
			var cur_id = Globals.Global_Hotbar.get_selected_item().id
			if cur_id >= 0:
				var cur_item = Globals.Global_Item_Dictionary.get_item(cur_id)
				if min_quality > cur_item.tool_quality:
					# cannot mine if above min quality
					mining_speed = 0
				else:
					# the more levels above min quality a tool is, the better
					var diff = cur_item.tool_quality - min_quality
					mining_speed += diff * mining_speed
				if effective_tool != cur_item.tool_type:
					mining_speed *= 0.5
				timer -= mining_speed
			else:
				#empty inv slot, quality is 0, type is always wrong
				if min_quality > 0:
					# cannot mine if above min quality
					mining_speed = 0
				mining_speed *= 0.5
		if Input.is_action_just_released("mine") and timer > 0 or not interest:
			timer = base_mine_time
		if timer <= 0:
			timer = 0
			Globals.Global_Player_Ref.add_item(id, res_yield)
			queue_free()


func _on_Tree_body_entered(body):
	if body.name == "Player":
		interaction = true


func _on_Tree_body_exited(body):
	if body.name == "Player":
		interaction = false


func _on_Hitbox_mouse_entered():
	interest = true


func _on_Hitbox_mouse_exited():
	interest = false
