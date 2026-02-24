class_name  PlantGrowSystem
var spawn_timer : float = 0.0
var spawn_interval : float = 7.0
var food_tile : Vector2i = Vector2i(5, 2)

func update(world : World, delta):
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		spawn_food_random(world)

func spawn_food_random(world : World):
	var cells = world.map_tiles.get_used_cells()  
	if cells.is_empty():
		return
	var cell = cells.pick_random()
	world.spawn_plant(cell, food_tile)
