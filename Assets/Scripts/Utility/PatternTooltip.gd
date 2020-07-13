extends Node


var flavorRef
var ingredientsRef


# Called when the node enters the scene tree for the first time.
func _ready():
	flavorRef = find_node("TooltipLabel")
	ingredientsRef = find_node("Ingredients")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
