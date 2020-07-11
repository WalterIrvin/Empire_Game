extends KinematicBody2D
var data_ref
var velocity = Vector2(0, 0)

func _ready():
	Globals.Global_Player_Ref = self
	data_ref = Globals.Global_Player_Data

func tick_needs(delta):
	# drains hunger / thirst by decay amt * delta
	if data_ref.hunger > 0:
		data_ref.hunger -= delta * data_ref.hunger_rate
	if data_ref.thirst > 0:
		data_ref.thirst -= delta * data_ref.thirst_rate
	if data_ref.hunger <= 0:
		data_ref.hunger = 0
		data_ref.health -= delta * data_ref.starve_damage 
	if data_ref.thirst <= 0:
		data_ref.thirst = 0
		data_ref.health -= delta * data_ref.dehydrate_damage
	if data_ref.health <= 0:
		data_ref.health = 0

func update_bars():
	update_health()
	update_hunger()
	update_thirst()

func update_health():
	var pct = data_ref.health / data_ref.max_health
	Globals.Global_Healthbar.value = pct * 100
	
func update_hunger():
	var pct = data_ref.hunger / data_ref.max_hunger
	Globals.Global_Hungerbar.value = pct * 100

func update_thirst():
	var pct = data_ref.thirst / data_ref.max_thirst
	Globals.Global_Thirstbar.value = pct * 100

func _process(delta):
	if data_ref == null:
		data_ref = Globals.Global_Player_Data
	process_input()
	velocity = move_and_slide(velocity)
	tick_needs(delta)
	update_bars()
	
func process_input():
	velocity = Vector2(0, 0)
	if Input.is_action_pressed("up"):
		velocity.y = -data_ref.speed
	if Input.is_action_pressed("down"):
		velocity.y = data_ref.speed
	if Input.is_action_pressed("left"):
		velocity.x = -data_ref.speed
	if Input.is_action_pressed("right"):
		velocity.x = data_ref.speed
	if data_ref.hunger <= 0:
		velocity *= 0.5
	if data_ref.thirst <= 0:
		velocity *= 0.5
	if data_ref.health <= 0:
		velocity *= 0

func add_item(id, amt):
	Globals.Global_Inventory.add_item(id, amt)
