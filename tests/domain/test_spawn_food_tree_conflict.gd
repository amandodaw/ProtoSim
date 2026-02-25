extends RefCounted

const GameStateRef = preload("res://scripts/domain/state/game_state.gd")
const EventBusRef = preload("res://scripts/domain/events/domain_event_bus.gd")


func run() -> bool:
	return _test_skip_food_spawn_on_tree_cell() and _test_spawn_food_on_free_cell()


func _test_skip_food_spawn_on_tree_cell() -> bool:
	var ctx := GameContext.new()
	ctx.game_state = GameStateRef.new()
	ctx.event_bus = EventBusRef.new()
	ctx.registry = EcsRegistry.new()

	var occupied_cell = Vector2i(2, 2)
	ctx.map_tiles = _new_tile_layer([occupied_cell])
	ctx.food_tiles = _new_tile_layer()
	ctx.game_state.add_tree(50, occupied_cell, Vector2(2, 2), 1, 2, 8.0)

	var spawn_system := SpawnSystem.new()
	spawn_system.spawn_food_random(ctx)

	var ok = ctx.game_state.get_plant_id_by_cell(occupied_cell) == -1
	ctx.map_tiles.free()
	ctx.food_tiles.free()
	return ok


func _test_spawn_food_on_free_cell() -> bool:
	var ctx := GameContext.new()
	ctx.game_state = GameStateRef.new()
	ctx.event_bus = EventBusRef.new()
	ctx.registry = EcsRegistry.new()

	var free_cell = Vector2i(3, 3)
	ctx.map_tiles = _new_tile_layer([free_cell])
	ctx.food_tiles = _new_tile_layer()

	var spawn_system := SpawnSystem.new()
	spawn_system.spawn_food_random(ctx)

	var ok = ctx.game_state.get_plant_id_by_cell(free_cell) != -1
	ctx.map_tiles.free()
	ctx.food_tiles.free()
	return ok


func _new_tile_layer(cells: Array = []) -> TileMapLayer:
	var tile_layer := TileMapLayer.new()
	var tile_set := TileSet.new()
	var source := TileSetAtlasSource.new()
	var image := Image.create(16, 16, false, Image.FORMAT_RGBA8)
	image.fill(Color.WHITE)
	var texture := ImageTexture.create_from_image(image)
	source.texture = texture
	source.texture_region_size = Vector2i(16, 16)
	source.create_tile(Vector2i.ZERO)
	tile_set.add_source(source, 0)
	tile_layer.tile_set = tile_set

	for cell in cells:
		tile_layer.set_cell(cell, 0, Vector2i.ZERO)

	return tile_layer
