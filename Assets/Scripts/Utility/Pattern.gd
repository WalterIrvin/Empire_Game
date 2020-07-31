extends Control

var patternListRef = null
var recipeName = null
var recipeIcon = null
export var recipe_id = 0

func _ready():
	recipeIcon = find_node("RecipeIcon")
	recipeName = find_node("RecipeText")
	var parent = get_parent()
	while parent != null:
		if parent.name == "PatternList":
			patternListRef = parent
			break
		parent = parent.get_parent()

func set_recipe(id):
	# Sets the recipe id / name / icon of a crafting pattern
	recipe_id = id
	var item_id = Globals.Global_Recipe_Dictionary.get_output_item_id(id)
	var item = Globals.Global_Item_Dictionary.get_item(item_id)
	recipeName.text = item.name
	recipeIcon.texture = item.get_texture()


func _on_IconButton_button_down():
	"""Used to select this pattern as current active pattern"""
	if patternListRef != null:
		patternListRef.switch_cur_selected_pattern(recipe_id)
