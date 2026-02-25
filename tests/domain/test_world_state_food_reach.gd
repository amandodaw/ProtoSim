extends RefCounted

const GameStateRef = preload("res://scripts/domain/state/game_state.gd")


func run() -> bool:
	return _test_food_reachable_matches_interaction_distance()


func _test_food_reachable_matches_interaction_distance() -> bool:
	var ctx := GameContext.new()
	ctx.game_state = GameStateRef.new()
	ctx.registry = EcsRegistry.new()

	var entity = 1
	ctx.registry.add(entity, AgentWorldStateComponent.new())
	ctx.registry.add(entity, VisiblePlantsComponent.new())
	ctx.registry.add(entity, PositionComponent.new())

	var hunger := HungerComponent.new()
	var inventory := InventoryComponent.new()
	var health := HealthComponent.new()
	ctx.game_state.register_agent(entity, hunger, inventory, health)

	ctx.game_state.add_plant(10, Vector2i(1, 1), Vector2(10, 0), 2, 2, 5.0)

	var visible = ctx.registry.get_component(entity, VisiblePlantsComponent)
	visible.closest = 10
	visible.plants = [10]

	var pos = ctx.registry.get_component(entity, PositionComponent)
	pos.value = Vector2.ZERO

	var system = WorldStateSystem.new()
	system.update(ctx, 0.016)

	var state = ctx.registry.get_component(entity, AgentWorldStateComponent)
	return state.food_visible and not state.food_reachable
