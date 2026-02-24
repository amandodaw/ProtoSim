class_name SpawnSystem

var spawn_timer : float = 0.0
var spawn_interval : float = 1.0

var plant_tiles = {
	0: Vector2i(2,1) 
}

func update(ctx: GameContext, delta: float):

	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		spawn_food_random(ctx)

func spawn_food_random(ctx: GameContext):

	var cells = ctx.map_tiles.get_used_cells()
	if cells.is_empty():
		return

	var cell = cells.pick_random()

	if ctx.cell_to_entity.has(cell):
		return

	spawn_plant(ctx, cell)

func spawn_plant(ctx: GameContext, cell: Vector2i):

	var plant_id = ctx.registry.create_entity()

	var grow = PlantGrowComponent.new()
	grow.cell = cell
	ctx.registry.add(plant_id, grow)

	var pos = PositionComponent.new()
	pos.value = ctx.food_tiles.map_to_local(cell)
	ctx.registry.add(plant_id, pos)

	ctx.food_tiles.set_cell(cell, 0, plant_tiles[0])
	ctx.cell_to_entity[cell] = plant_id
