extends RefCounted

const GameStateRef = preload("res://scripts/domain/state/game_state.gd")
const EventBusRef = preload("res://scripts/domain/events/domain_event_bus.gd")


func run() -> bool:
	return _test_move_action_uses_closest_target() and _test_harvest_action_uses_closest_target() and _test_move_action_stops_when_target_is_lost()


func _new_context() -> GameContext:
	var ctx := GameContext.new()
	ctx.game_state = GameStateRef.new()
	ctx.event_bus = EventBusRef.new()
	ctx.registry = EcsRegistry.new()
	ctx.agent_actions = AgentActions.new()

	var entity = 1
	ctx.registry.add(entity, VisiblePlantsComponent.new())
	ctx.registry.add(entity, PositionComponent.new())
	ctx.registry.add(entity, MovementComponent.new())

	return ctx


func _test_move_action_uses_closest_target() -> bool:
	var ctx = _new_context()

	ctx.game_state.add_plant(10, Vector2i(1, 1), Vector2(100, 0), 2, 2, 5.0)
	ctx.game_state.add_plant(11, Vector2i(2, 2), Vector2(10, 0), 2, 2, 5.0)

	var visible = ctx.registry.get_component(1, VisiblePlantsComponent)
	visible.plants = [10, 11]
	visible.closest = 11

	var pos = ctx.registry.get_component(1, PositionComponent)
	pos.value = Vector2.ZERO

	var movement = ctx.registry.get_component(1, MovementComponent)
	var action = GoapMoveToFood.new()
	action.perform(ctx, 1)

	if action.target_plant != 11:
		return false

	return movement.direction.x > 0.0 and absf(movement.direction.y) < 0.001


func _test_harvest_action_uses_closest_target() -> bool:
	var ctx = _new_context()

	ctx.game_state.add_plant(20, Vector2i(3, 3), Vector2(100, 0), 2, 2, 5.0)
	ctx.game_state.add_plant(21, Vector2i(4, 4), Vector2(10, 0), 2, 2, 5.0)

	var visible = ctx.registry.get_component(1, VisiblePlantsComponent)
	visible.plants = [20, 21]
	visible.closest = 21

	var pos = ctx.registry.get_component(1, PositionComponent)
	pos.value = Vector2.ZERO

	var action = GoapHarvestFood.new()
	action.perform(ctx, 1)

	return action.target_plant == 21


func _test_move_action_stops_when_target_is_lost() -> bool:
	var ctx = _new_context()

	ctx.game_state.add_plant(30, Vector2i(2, 2), Vector2(100, 0), 2, 2, 5.0)

	var visible = ctx.registry.get_component(1, VisiblePlantsComponent)
	visible.plants = [30]
	visible.closest = 30

	var pos = ctx.registry.get_component(1, PositionComponent)
	pos.value = Vector2.ZERO

	var movement = ctx.registry.get_component(1, MovementComponent)
	var action = GoapMoveToFood.new()
	action.perform(ctx, 1)

	if movement.direction == Vector2.ZERO:
		return false

	ctx.game_state.remove_plant(30)
	action.perform(ctx, 1)

	return movement.direction == Vector2.ZERO
