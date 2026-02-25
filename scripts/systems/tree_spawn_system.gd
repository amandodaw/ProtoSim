class_name TreeSpawnSystem

const DomainEventsRef = preload("res://scripts/domain/events/events.gd")

var spawn_timer: float = 0.0
var spawn_interval: float = 2.5


func update(ctx: GameContext, delta: float):
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		spawn_tree_random(ctx)


func spawn_tree_random(ctx: GameContext):
	var cells = ctx.map_tiles.get_used_cells()
	if cells.is_empty():
		return

	var cell = cells.pick_random()
	if ctx.game_state.get_tree_id_by_cell(cell) != -1:
		return

	if ctx.game_state.get_plant_id_by_cell(cell) != -1:
		return

	spawn_tree(ctx, cell)


func spawn_tree(ctx: GameContext, cell: Vector2i):
	var tree_id = ctx.registry.create_entity()
	var position = ctx.tree_tiles.map_to_local(cell)
	var tree_state = ctx.game_state.add_tree(tree_id, cell, position)
	ctx.event_bus.publish(DomainEventsRef.tree_spawned(tree_id, cell, tree_state.stage))
