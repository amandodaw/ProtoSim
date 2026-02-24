class_name SpawnSystem

var spawn_timer : float = 0.0
var spawn_interval : float = 7.0

var plant_tiles = {
	0: Vector2i(2,1) 
}

func update(world: World, delta: float):

	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		spawn_food_random(world)

func spawn_food_random(world: World):

	var cells = world.map_tiles.get_used_cells()
	if cells.is_empty():
		return

	var cell = cells.pick_random()

	if world.cell_to_entity.has(cell):
		return

	spawn_plant(world, cell)

func spawn_plant(world: World, cell: Vector2i):

	var plant_id = world.create_entity()

	var grow = PlantGrowComponent.new()
	grow.cell = cell
	world.add(plant_id, grow)

	var pos = PositionComponent.new()
	pos.value = world.food_tiles.map_to_local(cell)
	world.add(plant_id, pos)

	world.food_tiles.set_cell(cell, 0, plant_tiles[0])
	world.cell_to_entity[cell] = plant_id
