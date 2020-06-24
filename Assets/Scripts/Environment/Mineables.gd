extends Area2D

export var res_type = "none"
export var amt = 1  # amt yielded when mined
export var base_mine_time = 1  # in seconds
var player_ref = null
var interaction = false  # player within interaction range
var interest = false  # player mouse hovering over node
var timer
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	timer = base_mine_time


func _process(delta):
	if interaction and player_ref != null:
		if Input.is_action_pressed("mine") and timer >= 0 and interest:
			timer -= delta
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
