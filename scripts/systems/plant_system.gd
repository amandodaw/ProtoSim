class_name  PlantSystem

const DomainEventsRef = preload("res://scripts/domain/events/events.gd")

func update(ctx: GameContext, delta: float):
	for plant_id in ctx.game_state.plants.keys():
		var plant = ctx.game_state.get_plant(plant_id)
		if plant == null or plant.stage == plant.max_stage:
			continue
		plant.growth_timer += delta
		if plant.growth_timer >= plant.time_to_next_stage:
			plant.growth_timer = 0.0
			plant.stage += 1
			ctx.event_bus.publish(DomainEventsRef.plant_grown(plant.id, plant.cell, plant.stage))
			


func harvest(ctx: GameContext, plant_entity: int, harvester: int) -> bool:
	var plant = ctx.game_state.get_plant(plant_entity)
	if plant == null:
		return false

	if plant.stage < plant.max_stage:
		return false

	ctx.registry.destroy_entity(plant_entity)
	ctx.game_state.remove_plant(plant_entity)
	ctx.event_bus.publish(DomainEventsRef.plant_harvested(plant_entity, plant.cell, harvester))

	var agent = ctx.game_state.get_agent(harvester)
	if agent != null:
		agent.food += 1

	var inv = ctx.registry.get_component(harvester, InventoryComponent)
	if inv != null:
		if agent != null:
			inv.food = agent.food
		else:
			inv.food += 1

	return true
