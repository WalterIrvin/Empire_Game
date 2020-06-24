extends KinematicBody2D
var inventory = {"flint": 0, "wood": 0, "stick": 0}
var velocity = Vector2(0, 0)
var speed = 100
var inventory_ref

func _ready():
	inventory_ref = find_node("UI")

func _process(_delta):
	process_input()
	velocity = move_and_slide(velocity)

func process_input():
	velocity = Vector2(0, 0)
	if Input.is_action_pressed("up"):
		velocity.y = -speed
		
	if Input.is_action_pressed("down"):
		velocity.y = speed
		
	if Input.is_action_pressed("left"):
		velocity.x = -speed
		
	if Input.is_action_pressed("right"):
		velocity.x = speed

func add_item(res_type, amt):
	inventory_ref.add_item(res_type, amt)
