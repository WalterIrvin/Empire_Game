extends Node

class Item:
	var id = 0
	var name = "none"
	var stream_path = "null"
	var stack_count = 0
	var tool_type = "none"
	var tool_quality = "none"
	
	func _init(id, _name, path, stack, type, quality):
		self.id = id
		self.name = _name
		self.stream_path = path
		self.stack_count = stack
		self.tool_type = type
		self.tool_quality = quality

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

class PlayerData:
	var speed = 100
	var health = 100
	var max_health = 100
	var hunger = 100
	var max_hunger = 100
	var thirst = 100
	var max_thirst = 100 
	var hunger_rate = 1.05
	var thirst_rate = 0.09
	var starve_damage = 0.7
	var dehydrate_damage = 0.5

var path = "res://Assets/Data/item_info.txt"
var Global_Item_Dictionary = ItemDict.new(path)
var Global_Player_Data = PlayerData.new()
var Global_Player_Ref
var Global_Hotbar
var Global_Healthbar
var Global_Hungerbar
var Global_Thirstbar
var Global_Inventory
var Global_Floating_Ref