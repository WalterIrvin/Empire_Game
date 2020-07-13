extends Control

var patternListRef = null
export var recipe_id = 0

func _ready():
	var parent = get_parent()
	while parent != null:
		if parent.name == "PatternList":
			patternListRef = parent
			break
		parent = parent.get_parent()

func set_recipe(id):
	recipe_id = id


func _on_IconButton_button_down():
	"""Used to select this pattern as current active pattern"""
	if patternListRef != null:
		patternListRef.switch_cur_selected_pattern(recipe_id)
