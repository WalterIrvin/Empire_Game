extends TextureButton

var patternListRef = null
var disabled_icon = null
func _ready():
	disabled_icon = find_node("Disabled")
	var parent = get_parent()
	while parent != null:
		if parent.name == "PatternList":
			patternListRef = parent
			break
		parent = parent.get_parent()


func _process(_delta):
	# checks if recipe is valid, if not disables the crafting button
	var cur_id = patternListRef.cur_id
	var cur_recipe = Globals.Global_Recipe_Dictionary.get_recipe(cur_id)
	if not cur_recipe.check_recipe(1):
		self.disabled = true
		disabled_icon.visible = true
	else:
		self.disabled = false
		disabled_icon.visible = false
