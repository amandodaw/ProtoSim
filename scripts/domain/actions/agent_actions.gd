class_name AgentActions

const DomainEventsRef = preload("res://scripts/domain/events/events.gd")


func harvest(ctx: GameContext, entity: int) -> bool:
	var pos_comp = ctx.registry.get_component(entity, PositionComponent)
	if pos_comp == null:
		return false

	var cell = ctx.food_tiles.local_to_map(pos_comp.value)
	var plant_id = ctx.game_state.get_plant_id_by_cell(cell)
	if plant_id == -1:
		return false

	return harvest_entity(ctx, entity, plant_id)


func harvest_entity(ctx: GameContext, entity: int, plant_id: int) -> bool:
	return ctx.plant_system.harvest(ctx, plant_id, entity)


func chop(ctx: GameContext, entity: int) -> bool:
	if ctx.tree_tiles == null or ctx.tree_system == null:
		return false

	var pos_comp = ctx.registry.get_component(entity, PositionComponent)
	if pos_comp == null:
		return false

	var cell = ctx.tree_tiles.local_to_map(pos_comp.value)
	var movement = ctx.registry.get_component(entity, MovementComponent)
	var adjacent_cells = _get_adjacent_cells_by_facing(cell, movement)

	for target_cell in adjacent_cells:
		var tree_id = ctx.game_state.get_tree_id_by_cell(target_cell)
		if tree_id == -1:
			continue
		return ctx.tree_system.chop(ctx, tree_id, entity)

	return false


func _get_adjacent_cells_by_facing(origin: Vector2i, movement: MovementComponent) -> Array:
	var facing = Vector2.RIGHT
	if movement != null:
		if movement.direction != Vector2.ZERO:
			facing = _cardinal_from_direction(movement.direction)
			movement.facing = facing
		else:
			facing = _cardinal_from_direction(movement.facing)

	var forward = Vector2i(int(facing.x), int(facing.y))
	var offsets: Array[Vector2i] = [
		forward,
		Vector2i.UP,
		Vector2i.DOWN,
		Vector2i.LEFT,
		Vector2i.RIGHT
	]

	var targets: Array = []
	for offset in offsets:
		if offset == Vector2i.ZERO:
			continue
		if targets.has(offset):
			continue
		targets.append(origin + offset)

	return targets


func _cardinal_from_direction(dir: Vector2) -> Vector2:
	if dir == Vector2.ZERO:
		return Vector2.RIGHT

	if absf(dir.x) >= absf(dir.y):
		return Vector2.RIGHT if dir.x >= 0.0 else Vector2.LEFT

	return Vector2.DOWN if dir.y >= 0.0 else Vector2.UP


func eat(ctx: GameContext, entity: int, eat_amount: float = 50.0) -> bool:
	var agent = ctx.game_state.get_agent(entity)
	if agent == null:
		return false

	if agent.food > 0 and agent.hunger < agent.max_hunger:
		agent.food -= 1
		agent.hunger = minf(agent.hunger + eat_amount, agent.max_hunger)

		var inventory = ctx.registry.get_component(entity, InventoryComponent)
		if inventory != null:
			inventory.food = agent.food

		var hunger = ctx.registry.get_component(entity, HungerComponent)
		if hunger != null:
			hunger.value = agent.hunger

		ctx.event_bus.publish(DomainEventsRef.food_eaten(entity, eat_amount, agent.hunger, agent.food))
		return true

	return false
