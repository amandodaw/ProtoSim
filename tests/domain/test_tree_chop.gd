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
	ctx.tree_system = tree_system

	var hunger := HungerComponent.new()
	var inventory := InventoryComponent.new()
	var health := HealthComponent.new()
	ctx.game_state.register_agent(1, hunger, inventory, health)
	ctx.registry.add(1, inventory)

	ctx.game_state.add_tree(100, Vector2i(3, 3), Vector2(24, 24), 1, 2, 8.0)
	if not tree_system.chop(ctx, 100, 1):
		return false

	var agent = ctx.game_state.get_agent(1)
	if agent == null:
		return false
	if agent.wood != 0:
		return false

	ctx.game_state.add_tree(101, Vector2i(4, 4), Vector2(32, 32), 2, 2, 8.0)
	if not tree_system.chop(ctx, 101, 1):
		return false

	return agent.wood == 1
