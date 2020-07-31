extends Node

class Item:
	var id = 0
	var name = "none"
	var stream_path = "null"
	var stack_count = 0
	var tool_type = "none"
	var tool_quality = "none"
	
	func _init(_id, _name, path, stack, type, quality):
		self.id = _id
		self.name = _name
		self.stream_path = path
		self.stack_count = stack
		self.tool_type = type
		self.tool_quality = quality
	
	func get_texture():
		var texture = StreamTexture.new()
		texture.load_path = stream_path
		return texture
	
class ItemDict:
	var item_dictionary = {}
	func _init(fname):
		# open up
		var file = File.new()
		if file.open(fname, File.READ) != 0:
			print("error opening file")
			return
		var begin_read = false
		while not file.eof_reached():
			var line = file.get_line()
			if begin_read:
				var split_vals = line.split(",")
				var _id = int(split_vals[0])
				var _name = str(split_vals[1])
				var _path = str(split_vals[2])
				var _stack = int(split_vals[3])
				var _type = int(split_vals[4])
				var _quality = int(split_vals[5])
				var _item = Item.new(_id, _name, _path, _stack, _type, _quality)
				item_dictionary[_id] = _item
			if line == "[ITEM_SECTION]":
				begin_read = true
		file.close()
		
	func get_item(id):
		# Returns item if found, else null
		if self.item_dictionary.has(int(id)):
			return self.item_dictionary[int(id)]
		else:
			return null
			
	func has(id):
		# wrapper for dictionary.has
		return self.item_dictionary.has(id)

class Recipe:
	var recipe_id = 0  #id in the recipe dictionary
	var id_amt_pair = []  #2d array [[id:amt], ...]
	var output_id = 0  #the id of the final crafted item
	var output_amt = 0  #base amt created from the recipe
	func _init(input_id, pairs, crafted_id, crafted_amt):
		recipe_id = input_id
		id_amt_pair = pairs
		output_id = crafted_id
		output_amt = crafted_amt
		
	func check_recipe(amt):
		# checks if recipe is valid, returns true/false respectively
		if Globals.Global_Inventory != null:
			# check if the inventory has enough of all items for the amt needed
			for pair in id_amt_pair:
				var _id = pair[0]
				var _amt = pair[1] * amt
				if not Globals.Global_Inventory.check_item(_id, _amt):
					return false
			return true
		else:
			return false
			
	func craft(amt):
		# checks the inventory of player to see if they have the needed
		# ingredients to make create the item. Crafts item up to amt if possible
		# returns true if successful, false otherwise
		var valid = check_recipe(amt)
		if valid:
			# Removes all the items, after having check all are enough
			for pair in id_amt_pair:
				var _id = pair[0]
				var _amt = pair[1] * amt
				Globals.Global_Inventory.remove_item(_id, _amt)
			# adds the crafted item * amt at the end
			Globals.Global_Inventory.add_item(output_id, amt * output_amt)
			return true
		else:
			return false


class RecipeDict:
	var recipe_dict = {}
	func _init(path):
		var file = File.new()
		if file.open(path, File.READ) != 0:
			print("error opening file")
			return
		var begin_read = false
		while not file.eof_reached():
			var line = file.get_line()
			if begin_read:
				var side = line.split(";")
				# right hand side
				var right_side = side[1].split(",")
				var output_id = int(right_side[0])
				var output_amt = int(right_side[1])
				# left hand side
				var input = side[0]
				var pattern = input.split(",")
				# final vars + splitting id:amt lists
				var recipe_id = int(pattern[0])
				var id_amt_pairs = []
				for i in range(1, len(pattern)):
					var cur_pair = pattern[i].split(":")
					id_amt_pairs.append([int(cur_pair[0]), int(cur_pair[1])])
				# recipe building section
				var new_recipe = Recipe.new(recipe_id, id_amt_pairs, output_id, output_amt)
				recipe_dict[recipe_id] = new_recipe
			if line == "[RECIPE_SECTION]":
				begin_read = true
		file.close()
		
	func get_output_item_id(id):
		"""gets the crafted item id for a given recipe id, returns null
		if no output found"""
		var recipe = get_recipe(id)
		if recipe == null:
			return null
		else:
			var item_id = recipe.output_id
			return item_id
			
	func get_recipe(id):
		"""gets the recipe with specified id, returns null
		if no recipe found."""
		if recipe_dict.has(int(id)):
			return recipe_dict[int(id)]
		else:
			return null
	
	func has(id):
		return recipe_dict.has(id)


class PlayerData:
	var speed = 100
	var health = 100
	var max_health = 100
	var hunger = 100
	var max_hunger = 100
	var thirst = 100
	var max_thirst = 100 
	var hunger_rate = 0.15
	var thirst_rate = 0.09
	var starve_damage = 0.7
	var dehydrate_damage = 0.5

var path = "res://Assets/Data/item_info.txt"
var recipe_path = "res://Assets/Data/recipe_info.txt"
var Global_Item_Dictionary = ItemDict.new(path)
var Global_Recipe_Dictionary = RecipeDict.new(recipe_path)
var Global_Player_Data = PlayerData.new()
var Global_Player_Ref
var Global_Hotbar
var Global_Healthbar
var Global_Hungerbar
var Global_Thirstbar
var Global_Inventory
var Global_Floating_Ref

