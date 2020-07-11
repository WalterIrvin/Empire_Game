extends TextureButton
export (StreamTexture) var slot_normal_texture
export (StreamTexture) var slot_activated_texture
export var id = -1 # invalid id means empty slot
export var amt = 0
var img_ref  # ref to item image texture
var amt_ref  # ref to text label for stack count
var activated = false  # used for hotbar slots

func _ready():
	img_ref = get_child(1)
	img_ref.texture = null
	amt_ref = get_child(2)
	if amt == 0 or amt == 1:
		amt_ref.text = ""
		
func _process(_delta):
	if id < 0:
		amt = 0
		img_ref.texture = null
	else:
		var cur_item = Globals.Global_Item_Dictionary.get_item(id)
		var cur_stex = StreamTexture.new()
		cur_stex.load_path = cur_item.stream_path
		img_ref.texture = cur_stex
	if amt >= 2:
		amt_ref.text = "x" + str(amt)
	else:
		amt_ref.text = ""
		
func _on_Item_gui_input(event):
	if Input.is_action_just_pressed("left_click"):
		selection_logic(0)
	elif Input.is_action_just_pressed("right_click"):
		selection_logic(1)

func selection_logic(click_type):
	"""Handles the swapping between the slot and floating selection.
	Left click is represented as 0, right as 1. Left click will grab whole
	selection or fill selection until floating selection is gone or max stack
	on inventory slot is reached, vice versa. Right click will split stacks,
	rounded up to next nearest integer, else deposit
	1 item if from a floating selection into a same id/empty tile."""
	var selection = Globals.Global_Floating_Ref
	if click_type == 0:
		if selection.id == id:
			#Floating selection has at least one item (0 amt = -1 id) same type
			#Grab as much from slot until selection is at max amt.
			fill_selection()
		elif selection.id != id:
			# selection/slot is either empty or with different item, swap
			swap_selections()
	elif click_type == 1:
		if id != selection.id and id == -1:
			# selection is not empty but slot is, deposit 1 up to max
			deposit_one_from_selection()
		elif id == selection.id and id != -1:
			# selection and slot are the same, deposit 1 up to max
			deposit_one_from_selection()
		elif id != -1 and selection.id == -1:
			# selection is empty, but slot is not, so take half from slot.
			take_half_slot()
		elif id != -1 and selection.id != -1 and selection.id != id:
			# the selection and slot are both non-empty and different, swap
			swap_selections()

func fill_selection():
	"""Fills the selection, checks if slot is empty first before doing anything.
	If slot is not empty, it will increase amt of selection until max stack,
	provided there are enough items to do so."""
	if Globals.Global_Item_Dictionary.has(id):
		var cur_item = Globals.Global_Item_Dictionary.get_item(id)
		var selection = Globals.Global_Floating_Ref
		var diff = cur_item.stack_count - selection.amt
		if diff > amt:
			# need more items to fill selection then are available
			selection.amt += amt
			amt = 0
			id = -1
		else:
			# slot has >= items to fill selection
			amt -= diff
			selection.amt += diff

func take_half_slot():
	"""Takes half(ceiling) of the items in slot and puts it into selection.""" 
	var half_ceil = ceil(amt / 2.0)
	var selection = Globals.Global_Floating_Ref
	if amt > 1:
		amt -= half_ceil
		selection.id = id
		selection.amt += half_ceil
	else:
		# slot cannot be split, give selection 1 item and set slot to empty
		selection.id = id
		selection.amt = 1
		amt = 0
		id = -1

func deposit_one_from_selection():
	"""Deposits one item from selection to the slot."""
	var cur_item = Globals.Global_Item_Dictionary.get_item(id)
	var selection = Globals.Global_Floating_Ref
	if Globals.Global_Item_Dictionary.has(id):
		if cur_item.stack_count >= 1 + amt:
			selection.amt -= 1
			amt += 1
		else:
			swap_selections()
	else:
		selection.amt -= 1
		id = selection.id
		amt += 1

func swap_selections():
	"""Swaps the items between the slot and the selection."""
	var tmp_id = id
	var tmp_amt = amt
	var selection = Globals.Global_Floating_Ref
	id = selection.id
	amt = selection.amt
	selection.id = tmp_id
	selection.amt = tmp_amt
	
func activate():
	texture_normal = slot_activated_texture
	
func deactivate():
	texture_normal = slot_normal_texture

