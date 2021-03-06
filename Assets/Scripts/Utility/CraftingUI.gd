extends CanvasLayer
var is_hidden = false
var slot_list = []
var inv_grid
var bg_ref
var hotbar_ref
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.Global_Inventory = self
	bg_ref = find_node("BG")
	inv_grid = find_node("InvGrid")

func _process(_delta):
	if hotbar_ref == null:
		hotbar_ref = Globals.Global_Hotbar
		for y in range(Globals.Global_Hotbar.get_child_count()):
			slot_list.append(Globals.Global_Hotbar.get_child(y))
		for i in range(inv_grid.get_child_count()):
			slot_list.append(inv_grid.get_child(i))
			
	if Input.is_action_just_pressed("open_inventory"):
		if not is_hidden:
			is_hidden = true
			bg_ref.hide()
		else:
			is_hidden = false
			bg_ref.show()

func add_item(id, amt):
	"""Adds items to the array of inventorySlot objects, items are added to
	the hotbar first, then to the rest of the inventory slots starting from
	top left."""
	var global_dict = Globals.Global_Item_Dictionary
	if global_dict.has(id):
		var _item = global_dict.get_item(id)
		for slot in slot_list:
			if amt == 0:
				break
			if global_dict.has(slot.id):
				# is not an empty tile
				if slot.id == id:
					# can stack
					if _item.stack_count >= amt + slot.amt:
						slot.amt = amt + slot.amt
						amt = 0
					else:
						slot.amt = _item.stack_count
						amt -= _item.stack_count - slot.amt
			else:
				# is an empty tile
				if _item.stack_count >= amt:
					slot.id = id
					slot.amt = amt
					amt = 0
				else:
					slot.id = id
					slot.amt = _item.stack_count
					amt -= _item.stack_count
	else:
		print("id not found in item-dictionary: " + str(id))

func check_item(id, amt):
	# checks if >= amt of item-id exists in the inventory, returns true/false
	# keeps track of amt of items, even if split amongst several stacks
	var total_items = 0 
	for slot in slot_list:
		if slot.id == id:
			total_items += slot.amt
	if total_items >= amt:
		return true
	else:
		return false

func remove_item(id, amt):
	var total_left = amt
	for slot in slot_list:
		if slot.id == id:
			if total_left > slot.amt:
				total_left -= slot.amt
				slot.amt = 0
				slot.id = -1
			elif total_left <= slot.amt:
				slot.amt -= total_left
				total_left = 0
	if total_left > 0:
		print("Error: there are items still left to be removed: ", total_left)
