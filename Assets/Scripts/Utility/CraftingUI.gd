extends CanvasLayer

export var id_texture_dict = {}  # gives textures for each id
export var id_stack_dict = {}  # max stack size for each id
export var id_tool_type_dict = {} # what type of tool each relevant tool is
export var id_tool_quality_dict = {} # mining level of tool/what age it's from
var is_hidden = false
var slot_list = []
var inv_grid
var bg_ref
var hotbar_ref
# Called when the node enters the scene tree for the first time.
func _ready():
	hotbar_ref = find_node("Hotbar")
	bg_ref = find_node("BG")
	inv_grid = find_node("InvGrid")
	for y in range(hotbar_ref.get_child_count()):
		slot_list.append(hotbar_ref.get_child(y))
		
	for i in range(inv_grid.get_child_count()):
		slot_list.append(inv_grid.get_child(i))


func _process(_delta):
	if Input.is_action_just_pressed("open_inventory"):
		if not is_hidden:
			is_hidden = true
			bg_ref.hide()
		else:
			is_hidden = false
			bg_ref.show()

func add_item(res_type, amt):
	var amt_left = amt
	for slot in slot_list:
		if amt_left == 0:
			# nothing left to add
			break
			
		if slot.res_type == "none":
			# case 1 - empty slot to put item in
			if id_stack_dict.has(res_type) and id_texture_dict.has(res_type):
				var max_amt = id_stack_dict[res_type]
				var tile_texture = id_texture_dict[res_type]
				var tool_type = "none"
				var tool_quality = 0
				if id_tool_type_dict.has(res_type):
					tool_type = id_tool_type_dict[res_type]
				if id_tool_quality_dict.has(res_type):
					tool_quality = id_tool_quality_dict[res_type]
				if max_amt >= amt_left:
					# item fits into the one slot
					slot.tile_texture = tile_texture
					slot.res_type = res_type
					slot.res_amt = amt_left
					slot.stack_max = max_amt
					slot.tool_type = tool_type
					slot.tool_quality = tool_quality
					amt_left = 0
				else:
					# item needs > 1 slots to fill up
					slot.tile_texture = tile_texture
					slot.res_type = res_type
					slot.res_amt = max_amt
					slot.stack_max = max_amt
					slot.tool_type = tool_type
					slot.tool_quality = tool_quality
					amt_left -= max_amt
			else:
				print("Error: item type " + res_type + " not supported...")
				break
				
		if slot.res_type == res_type and res_type != "none":
			# case 2 - existing stack that can be added to
			if id_stack_dict.has(res_type):
				var max_amt = id_stack_dict[res_type]
				if slot.res_amt + amt_left <= max_amt:
					# can fit into the one stack, break out of loop
					slot.res_amt += amt_left
					amt_left = 0
				else:
					# cannot fit into the one stack, take dif and repeat
					var dif = max_amt - slot.res_amt
					slot.res_amt = max_amt
					amt_left -= dif
			else:
				print("Error: item type " + res_type + " not supported...")
				break 
	if amt_left != 0:
		print("Error: some items not added, amt left over: " + str(amt_left))

func check_recipe(recipe_dict):
	print("test")
