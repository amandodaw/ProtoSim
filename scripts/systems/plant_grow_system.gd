class_name  PlantGrowSystem
var spawn_timer : float = 0.0
var spawn_interval : float = 7.0
var plant_tiles = {
	0: Vector2i(2, 1), # semilla
	1: Vector2i(5, 1), # creciendo
	2: Vector2i(5, 2)  # madura
}

func update(world : World, delta):
	for entity in world.query([PlantGrowComponent]):
		var comp = world.get_component(entity, PlantGrowComponent)
		if comp.stage == comp.max_stage:
			continue
		comp.growth_timer += delta
		if comp.growth_timer >= comp.time_to_next_stage:
			comp.growth_timer = 0.0
			comp.stage += 1
			var new_tile = plant_tiles[comp.stage]
			world.food_tiles.set_cell(comp.cell, 0, new_tile)
			print("la planta ha crecido al stage: ", comp.stage)
			
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		spawn_food_random(world)

func spawn_food_random(world : World):
	var cells = world.map_tiles.get_used_cells()  
	if cells.is_empty():
		return
	var cell = cells.pick_random()
	world.spawn_plant(cell, plant_tiles[0])
