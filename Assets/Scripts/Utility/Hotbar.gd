extends HBoxContainer

var hotbar_slots = []
var cur_slot = 1

func _ready():
	for i in range(get_child_count()):
		hotbar_slots.append(get_child(i))


func _process(delta):
	process_input()
	set_active()
	for slot in hotbar_slots:
		if slot.activated:
			slot.activate()
		else:
			slot.deactivate()

func process_input():
	if Input.is_action_just_pressed("hotbar_one"):
		cur_slot = 1
	elif Input.is_action_just_pressed("hotbar_two"):
		cur_slot = 2
	elif Input.is_action_just_pressed("hotbar_three"):
		cur_slot = 3
	elif Input.is_action_just_pressed("hotbar_four"):
		cur_slot = 4
	elif Input.is_action_just_pressed("hotbar_five"):
		cur_slot = 5
	elif Input.is_action_just_pressed("hotbar_six"):
		cur_slot = 6
	elif Input.is_action_just_pressed("hotbar_seven"):
		cur_slot = 7
	elif Input.is_action_just_pressed("hotbar_eight"):
		cur_slot = 8
	elif Input.is_action_just_pressed("hotbar_nine"):
		cur_slot = 9

func set_active():
	for slot in hotbar_slots:
		slot.activated = false
	hotbar_slots[cur_slot - 1].activated = true
