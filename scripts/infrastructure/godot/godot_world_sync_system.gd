class_name GodotWorldSyncSystem

var plant_tiles = {
	0: Vector2i(2, 1),
	1: Vector2i(5, 1),
	2: Vector2i(5, 2)
}

var tree_tiles = {
	0: Vector2i(6, 1),
	1: Vector2i(6, 2),
	2: Vector2i(7, 2)
}


func update(ctx: GameContext, delta: float) -> void:
	var events = ctx.event_bus.pop_all()
	for event in events:
		var event_type = event.get("type", "")
		if event_type == "PlantSpawned":
			_sync_plant_tile(ctx, event["cell"], event["stage"], event["plant_id"])
		elif event_type == "PlantGrown":
			_sync_plant_tile(ctx, event["cell"], event["stage"], event["plant_id"])
		elif event_type == "PlantHarvested":
			ctx.food_tiles.erase_cell(event["cell"])
			ctx.cell_to_entity.erase(event["cell"])
		elif event_type == "TreeSpawned":
			_sync_tree_tile(ctx, event["cell"], event["stage"])
		elif event_type == "TreeGrown":
			_sync_tree_tile(ctx, event["cell"], event["stage"])
		elif event_type == "TreeChopped":
			ctx.tree_tiles.erase_cell(event["cell"])


func _sync_plant_tile(ctx: GameContext, cell: Vector2i, stage: int, plant_id: int) -> void:
	if not plant_tiles.has(stage):
		return
	ctx.food_tiles.set_cell(cell, 0, plant_tiles[stage])
	ctx.cell_to_entity[cell] = plant_id


func _sync_tree_tile(ctx: GameContext, cell: Vector2i, stage: int) -> void:
	if not tree_tiles.has(stage):
		return
	ctx.tree_tiles.set_cell(cell, 0, tree_tiles[stage])
