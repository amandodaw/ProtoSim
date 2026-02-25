extends RefCounted

const GameStateRef = preload("res://scripts/domain/state/game_state.gd")
const EventBusRef = preload("res://scripts/domain/events/domain_event_bus.gd")
const TreeSystemRef = preload("res://scripts/systems/tree_system.gd")


func run() -> bool:
	return _test_chop_adjacent_cardinal() and _test_no_chop_diagonal() and _test_prefers_facing_direction() and _test_fallback_to_other_adjacent()


func _new_context() -> GameContext:
	var ctx := GameContext.new()
	ctx.game_state = GameStateRef.new()
	ctx.event_bus = EventBusRef.new()
	ctx.registry = EcsRegistry.new()
	ctx.agent_actions = AgentActions.new()
	ctx.tree_system = TreeSystemRef.new()
	ctx.tree_tiles = _new_tile_layer()

	var hunger := HungerComponent.new()
	var inventory := InventoryComponent.new()
	var health := HealthComponent.new()
	ctx.game_state.register_agent(1, hunger, inventory, health)

	var pos := PositionComponent.new()
	pos.value = ctx.tree_tiles.map_to_local(Vector2i(5, 5))
	ctx.registry.add(1, pos)
	ctx.registry.add(1, inventory)
	ctx.registry.add(1, MovementComponent.new())

	return ctx


func _new_tile_layer() -> TileMapLayer:
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
	return tile_layer


func _test_chop_adjacent_cardinal() -> bool:
	var ctx = _new_context()
	ctx.game_state.add_tree(100, Vector2i(6, 5), Vector2(6, 5), 2, 2, 8.0)

	var movement = ctx.registry.get_component(1, MovementComponent)
	movement.facing = Vector2.RIGHT

	if not ctx.agent_actions.chop(ctx, 1):
		ctx.tree_tiles.free()
		return false

	var agent = ctx.game_state.get_agent(1)
	var ok = not ctx.game_state.has_tree(100) and agent != null and agent.wood == 1
	ctx.tree_tiles.free()
	return ok


func _test_no_chop_diagonal() -> bool:
	var ctx = _new_context()
	ctx.game_state.add_tree(101, Vector2i(6, 6), Vector2(6, 6), 2, 2, 8.0)

	var movement = ctx.registry.get_component(1, MovementComponent)
	movement.facing = Vector2.RIGHT

	if ctx.agent_actions.chop(ctx, 1):
		ctx.tree_tiles.free()
		return false

	var ok = ctx.game_state.has_tree(101)
	ctx.tree_tiles.free()
	return ok


func _test_prefers_facing_direction() -> bool:
	var ctx = _new_context()
	ctx.game_state.add_tree(110, Vector2i(5, 4), Vector2(5, 4), 2, 2, 8.0)
	ctx.game_state.add_tree(111, Vector2i(5, 6), Vector2(5, 6), 2, 2, 8.0)
	ctx.game_state.add_tree(112, Vector2i(4, 5), Vector2(4, 5), 2, 2, 8.0)
	ctx.game_state.add_tree(113, Vector2i(6, 5), Vector2(6, 5), 2, 2, 8.0)

	var movement = ctx.registry.get_component(1, MovementComponent)
	movement.facing = Vector2.UP

	if not ctx.agent_actions.chop(ctx, 1):
		ctx.tree_tiles.free()
		return false

	var ok = not ctx.game_state.has_tree(110) and ctx.game_state.has_tree(111) and ctx.game_state.has_tree(112) and ctx.game_state.has_tree(113)
	ctx.tree_tiles.free()
	return ok


func _test_fallback_to_other_adjacent() -> bool:
	var ctx = _new_context()
	ctx.game_state.add_tree(120, Vector2i(4, 5), Vector2(4, 5), 2, 2, 8.0)

	var movement = ctx.registry.get_component(1, MovementComponent)
	movement.facing = Vector2.RIGHT

	if not ctx.agent_actions.chop(ctx, 1):
		ctx.tree_tiles.free()
		return false

	var ok = not ctx.game_state.has_tree(120)
	ctx.tree_tiles.free()
	return ok
