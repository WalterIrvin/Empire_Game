extends Area2D

export var res_type = "none"
export var amt = 1  # amt yielded when mined
export var base_mine_time = 1  # in seconds
var player_ref = null
var interaction = false
var timer
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	timer = base_mine_time


func _process(delta):
	if interaction and player_ref != null:
		if Input.is_action_pressed("mine") and timer >= 0:
			timer -= delta
		elif Input.is_action_just_released("mine") and timer > 0:
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
