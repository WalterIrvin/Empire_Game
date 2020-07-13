extends Control
# The pattern list keeps tracks of crafting, and will have a ref to a container
# to multiple patterns, as well as a editor-definable recipe id list
# the recipe_id_list is a list of ints, which reference the global recipe dict
export var recipe_id_list = []
var recipe_list_ref
var cur_id = 0

func _ready():
	recipe_list_ref = find_node("Recipe_List")
	var pattern_template = load("res://Assets/Scenes/Utility/Pattern.tscn")
	for i in range(len(recipe_id_list)):
		var new_pattern = pattern_template.instance()
		recipe_list_ref.add_child(new_pattern)
		new_pattern.set_recipe(recipe_id_list[i])

func switch_cur_selected_pattern(recipe_id):
	cur_id = recipe_id


func _on_CraftingButton_button_down():
	if Globals.Global_Recipe_Dictionary.has(cur_id):
		var cur_recipe = Globals.Global_Recipe_Dictionary.get_recipe(cur_id)
		cur_recipe.craft(1)
	else:
		print("error, invalid recipe id: ", cur_id)
