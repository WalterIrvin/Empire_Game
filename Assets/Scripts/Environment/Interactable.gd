extends Area2D

export var res_type = "none"
export var amt = 1
var player_ref = null
var interaction = false

func _ready():
	# acquires resource type and amt from harvest from resource data node
	pass

func _process(_delta):
	if interaction:
		if Input.is_action_just_pressed("interact") and player_ref != null:
			player_ref.add_item(res_type, amt)
			queue_free()
		
func _on_Item_body_entered(body):
	if body.name == "Player":
		player_ref = body
		interaction = true


func _on_Item_body_exited(body):
	if body.name == "Player":
		interaction = false
