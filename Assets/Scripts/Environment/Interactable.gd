extends Area2D

export var id = 0
export var amt = 1
var player_ref = null
var interaction = false

func _ready():
	# acquires resource type and amt from harvest from resource data node
	player_ref = Globals.Global_Player_Ref

func _process(_delta):
	if player_ref == null:
		player_ref = Globals.Global_Player_Ref
	if interaction:
		if Input.is_action_just_pressed("interact") and player_ref != null:
			player_ref.add_item(id, amt)
			queue_free()
		
func _on_Item_body_entered(body):
	if body.name == "Player":
		interaction = true


func _on_Item_body_exited(body):
	if body.name == "Player":
		interaction = false
