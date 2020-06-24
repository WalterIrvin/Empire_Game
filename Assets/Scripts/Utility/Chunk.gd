extends Node2D
###
# Chunk handles the resource collection logic for all resource nodes inside
# the chunk. Pickups and mineable objects are managed by the chunk.
###
var resource_types = ["flint", "stone", "wood"]
var resource_nodes = []

func _ready():
	generate_chunk()
	
func generate_chunk():
	for n in get_children():
		resource_nodes.append(n)

#func _process(delta):
	#pass
