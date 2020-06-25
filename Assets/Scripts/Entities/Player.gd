extends KinematicBody2D
var inventory = {"flint": 0, "wood": 0, "stick": 0}
var velocity = Vector2(0, 0)
var speed = 100
var health = 100
var max_health = 100
var hunger = 100
var max_hunger = 100
var thirst = 100
var max_thirst = 100 
var hunger_rate = 10.05 # how much hunger per second to remove
var thirst_rate = 0.09  # how much thirst per second to remove
var starve_damage = 100.1  # how much damage per second from starving
var dehydrate_damage = 0.5  # how much damage per second from dehydration
var inventory_ref
var hotbar_ref
var health_ref
var hunger_ref
var thirst_ref

func _ready():
	inventory_ref = find_node("UI")
	hotbar_ref = find_node("Hotbar")
	health_ref = find_node("HealthBar")
	hunger_ref = find_node("HungerBar")
	thirst_ref = find_node("ThirstBar")
	update_bars()

func tick_needs(delta):
	# drains hunger / thirst by decay amt * delta
	if hunger > 0:
		hunger -= delta * hunger_rate
	if thirst > 0:
		thirst -= delta * thirst_rate
	if hunger <= 0:
		hunger = 0
		health -= delta * starve_damage 
	if thirst <= 0:
		thirst = 0
		health -= delta * dehydrate_damage
	if health <= 0:
		health = 0

func update_bars():
	update_health()
	update_hunger()
	update_thirst()

func update_health():
	var pct = health / max_health
	health_ref.value = pct * 100
	
func update_hunger():
	var pct = hunger / max_hunger
	hunger_ref.value = pct * 100

func update_thirst():
	var pct = thirst / max_thirst
	thirst_ref.value = pct * 100

func _process(delta):
	process_input()
	velocity = move_and_slide(velocity)
	tick_needs(delta)
	update_bars()
	
func get_hotbar():
	return hotbar_ref
	
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
	if hunger <= 0:
		velocity *= 0.5
	if thirst <= 0:
		velocity *= 0.5
	if health <= 0:
		velocity *= 0

func add_item(res_type, amt):
	inventory_ref.add_item(res_type, amt)
