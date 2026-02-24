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


func eat(ctx: GameContext, entity: int, eat_amount: float = 50.0) -> bool:
	var agent = ctx.game_state.get_agent(entity)
	if agent == null:
		return false

	if agent.food > 0 and agent.hunger < 150:
		agent.food -= 1
		agent.hunger += eat_amount

		var inventory = ctx.registry.get_component(entity, InventoryComponent)
		if inventory != null:
			inventory.food = agent.food

		var hunger = ctx.registry.get_component(entity, HungerComponent)
		if hunger != null:
			hunger.value = agent.hunger

		ctx.event_bus.publish(DomainEventsRef.food_eaten(entity, eat_amount, agent.hunger, agent.food))
		return true

	return false
