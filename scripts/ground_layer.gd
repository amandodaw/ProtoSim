extends TileMapLayer

func _ready():
	#z_index = -1
	var width = 50
	var height = 50

	var source_id = 0              # ID del atlas en el tileset
	var atlas_coords : Vector2i  # posición del tile dentro del atlas
	randomize()

	for x in range(width):
		for y in range(height):
			atlas_coords = Vector2i(randi_range(0, 2), 0) 
			set_cell(Vector2i(x, y), source_id, atlas_coords)
