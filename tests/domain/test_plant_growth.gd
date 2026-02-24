extends RefCounted

const GameStateRef = preload("res://scripts/domain/state/game_state.gd")
const EventBusRef = preload("res://scripts/domain/events/domain_event_bus.gd")


func run() -> bool:
	var ctx := GameContext.new()
	ctx.game_state = GameStateRef.new()
	ctx.event_bus = EventBusRef.new()
	ctx.registry = EcsRegistry.new()

	var plant_system := PlantSystem.new()
	ctx.game_state.add_plant(10, Vector2i(1, 1), Vector2(16, 16), 0, 2, 0.1)
	plant_system.update(ctx, 0.2)

	var plant = ctx.game_state.get_plant(10)
	if plant == null:
		return false

	return plant.stage == 1
