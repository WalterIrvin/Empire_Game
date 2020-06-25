extends TextureButton
export var tool_quality = 0
export var tool_type = "none"
export (StreamTexture) var slot_normal_texture
export (StreamTexture) var slot_activated_texture
export (StreamTexture) var tile_texture
export var res_type = "none"
export var res_amt = 0
export var stack_max = 64
var img_ref  # ref to item image texture
var amt_ref  # ref to text label for stack count
var floating_ref  # floating selection
var activated = false  # used for hotbar slots


func _ready():
	find_player()
	img_ref = get_child(1)
	amt_ref = get_child(2)
	if res_amt == 0 or res_amt == 1:
		amt_ref.text = ""
		
func find_player():
	var root_node = get_tree().get_root().get_node("LevelRoot")
	if floating_ref == null:
		for c in range(root_node.get_child_count()):
			print(root_node.get_child(c).name)
	var player = root_node.find_node("Player")
	print(player)
	if player != null:
		floating_ref = player.find_node("FloatCan").find_node("FloatingSelection")
		
func _process(_delta):
	if floating_ref == null:
		find_player()
	img_ref.texture = tile_texture
	if res_amt >= 2:
		amt_ref.text = "x" + str(res_amt)
	else:
		amt_ref.text = ""
		
	
func swap_selection(click_type):
	# swaps the floating selection with the current inventory.
	# click_type (0 = left, 1 = right)
	###
	# Logic for Inventory Slot
	# Right-click:
	# If selection empty , take half or 1
	# If floating selection is same type as inventory, and inventory is not max
	# then add one to the inventory slot and keep floating selection -1
	# If different types, swap similar to left click
	# Left-click:
	# If selection empty, take whole stack
	# If selection same type as inventory slot, take from selection and put into
	# the inventory slot, up until the inventory slot max amt is reached
	###
	if not is_instance_valid(floating_ref):
		floating_ref = null
		find_player()
		return
	else:
		if click_type == 1:
			# RIGHT CLICK
			if floating_ref.res_type == "none":
				# Case 1 - empty selection take half of slot (ceiling round)
				var raw = res_amt / 2.0
				if raw >= 1.0:
					# can be split
					var half = ceil(raw)
					res_amt -= half
					set_selection()
					floating_ref.res_amt = half
				else:
					# can't be split, just one item
					set_selection()
					clear_self()
				
			elif floating_ref.res_type == res_type or res_type == "none":
				# Case 2 - put one item into the slot, if not past max cap
				if res_amt + 1 <= stack_max:
					floating_ref.res_amt -= 1
					res_type = floating_ref.res_type
					res_amt += 1
					tile_texture = floating_ref.tile_texture
					floating_ref.tool_type = tool_type
					floating_ref.tool_quality = tool_quality
					if floating_ref.res_amt <= 0:
						clear_selection()
				else:
					swap_elements()
	
			elif floating_ref.res_type != res_type:
				# Case 3 - swap elements
				swap_elements()
				
		elif click_type == 0:
			# LEFT CLICK
			if floating_ref.res_type == "none":
				# Case 1 - empty selection take whole stack
				set_selection()
				clear_self()
				
			elif floating_ref.res_type == res_type:
				# Case 2 - selection same as slot, fill slot up to stack max
				var dif = stack_max - res_amt
				if dif == 0:
					# swap selection and slot
					swap_elements()
				if dif >= floating_ref.res_amt:
					# takes all of floating selection to fill
					res_amt += floating_ref.res_amt
					clear_selection()
				else:
					# takes some of floating selection to fill
					var remainder = floating_ref.res_amt - dif
					res_amt += dif
					floating_ref.res_amt = remainder
					
			elif res_type == "none" and floating_ref.res_type != "none":
				# Case 3 - nothing in slot, put the selection in it
				set_slot()
				clear_selection()
				
			elif res_type != floating_ref.res_type:
				# Case 4 - different things in selection and slot, swap them
				swap_elements()

func swap_elements():
	var tmp_res_type = res_type
	var tmp_res_amt = res_amt
	var tmp_tile_texture = tile_texture
	var tmp_tool_type = tool_type
	var tmp_tool_quality = tool_quality
	set_slot()
	floating_ref.res_type = tmp_res_type
	floating_ref.res_amt = tmp_res_amt
	floating_ref.tile_texture = tmp_tile_texture
	floating_ref.tool_type = tmp_tool_type
	floating_ref.tool_quality = tmp_tool_quality

func set_slot():
	res_type = floating_ref.res_type
	res_amt = floating_ref.res_amt
	tile_texture = floating_ref.tile_texture
	tool_type = floating_ref.tool_type
	tool_quality = floating_ref.tool_quality

func set_selection():
	floating_ref.res_type = res_type
	floating_ref.res_amt = res_amt
	floating_ref.tile_texture = tile_texture
	floating_ref.tool_type = tool_type
	floating_ref.tool_quality = tool_quality

func clear_selection():
	floating_ref.res_type = "none"
	floating_ref.res_amt = 0
	floating_ref.tile_texture = null
	floating_ref.tool_quality = 0
	floating_ref.tool_type = "none"

func clear_self():
	res_type = "none"
	res_amt = 0
	tile_texture = null
	img_ref.texture = tile_texture
	tool_quality = 0
	tool_type = "none"

func _on_Item_gui_input(event):
	if Input.is_action_just_pressed("left_click"):
		swap_selection(0)
	elif Input.is_action_just_pressed("right_click"):
		swap_selection(1)

func activate():
	texture_normal = slot_activated_texture
	
func deactivate():
	texture_normal = slot_normal_texture
