extends Node


var title_ref
var components_ref
var crafting_icon

# Called when the node enters the scene tree for the first time.
func _ready():
	title_ref = find_node("TooltipLabel")
	title_ref.text = ""
	components_ref = find_node("Ingredients")
	crafting_icon = find_node("CraftingIcon")
	# initial update on the tooltip to get first listed recipe
	var parent = get_parent()
	while parent != null:
		if parent.name == "PatternList":
			var patternListRef = parent
			var cur_id = patternListRef.cur_id
			update_tooltip(cur_id)
			break
		parent = parent.get_parent()


func update_tooltip(recipe_id):
	# updates the various text fields in the tooltip
	var item_id = Globals.Global_Recipe_Dictionary.get_output_item_id(recipe_id)
	var output_item = Globals.Global_Item_Dictionary.get_item(item_id)
	var recipe = Globals.Global_Recipe_Dictionary.get_recipe(recipe_id)
	title_ref.text = output_item.name
	var comp_list = ""
	for i in range(len(recipe.id_amt_pair)):
		var id = recipe.id_amt_pair[i][0]
		var comp_item = Globals.Global_Item_Dictionary.get_item(id)
		var amt = recipe.id_amt_pair[i][1]
		var tmp_str = "x" + str(amt) + " " + comp_item.name + "\n"
		comp_list += tmp_str
	components_ref.text = comp_list
	crafting_icon.texture = output_item.get_texture()
