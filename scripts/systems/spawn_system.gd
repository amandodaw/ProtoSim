class_name SpawnSystem

const DomainEventsRef = preload("res://scripts/domain/events/events.gd")

var spawn_timer : float = 0.0
var spawn_interval : float = 1.0

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

	if ctx.game_state.get_plant_id_by_cell(cell) != -1:
		return

	spawn_plant(ctx, cell)

func spawn_plant(ctx: GameContext, cell: Vector2i):

	var plant_id = ctx.registry.create_entity()
	var position = ctx.food_tiles.map_to_local(cell)
	var plant_state = ctx.game_state.add_plant(plant_id, cell, position)
	ctx.event_bus.publish(DomainEventsRef.plant_spawned(plant_id, cell, plant_state.stage))
