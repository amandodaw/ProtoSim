extends RefCounted

const GameStateRef = preload("res://scripts/domain/state/game_state.gd")
const EventBusRef = preload("res://scripts/domain/events/domain_event_bus.gd")
const TreeSystemRef = preload("res://scripts/systems/tree_system.gd")


func run() -> bool:
	var ctx := GameContext.new()
	ctx.game_state = GameStateRef.new()
	ctx.event_bus = EventBusRef.new()
	ctx.registry = EcsRegistry.new()

	var tree_system = TreeSystemRef.new()
	ctx.game_state.add_tree(20, Vector2i(2, 2), Vector2(16, 16), 0, 2, 0.1)
	tree_system.update(ctx, 0.11)
	tree_system.update(ctx, 0.11)

	var tree = ctx.game_state.get_tree(20)
	if tree == null:
		return false

	return tree.stage == 2
