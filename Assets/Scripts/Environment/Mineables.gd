extends Area2D

export (StreamTexture) var tile_texture
export var effective_tool = "none"  # effective tool
export  var min_quality = 0 # quality needed to mine
export var res_type = "none"
export var amt = 1  # amt yielded when mined
export var base_mine_time = 1  # in seconds
var player_ref = null
var interaction = false  # player within interaction range
var interest = false  # player mouse hovering over node
var timer
var progress_bar
var sprite_ref
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	timer = base_mine_time
	progress_bar = find_node("Mining_Progress")
	sprite_ref = find_node("Mineable_Sprite")


func _process(delta):
	sprite_ref.texture = tile_texture
	if not interaction:
		progress_bar.hide()
	if interaction and player_ref != null:
		var hotbar_ref = player_ref.get_hotbar()
		var cur_item = hotbar_ref.get_selected_item()
		var amt_left = timer / base_mine_time
		progress_bar.value = amt_left * 100
		progress_bar.show()
		if Input.is_action_pressed("mine") and timer >= 0 and interest:
			var mining_speed = delta
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
		if Input.is_action_just_released("mine") and timer > 0 or not interest:
			timer = base_mine_time
		if timer <= 0:
			timer = 0
			player_ref.add_item(res_type, amt)
			queue_free()


func _on_Tree_body_entered(body):
	if body.name == "Player":
		player_ref = body
		interaction = true


func _on_Tree_body_exited(body):
	if body.name == "Player":
		interaction = false


func _on_Hitbox_mouse_entered():
	interest = true


func _on_Hitbox_mouse_exited():
	interest = false
