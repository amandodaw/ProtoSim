class_name AgentActions


func harvest(ctx: GameContext, entity: int) -> bool:
	var pos_comp = ctx.registry.get_component(entity, PositionComponent)
	if pos_comp == null:
		return false

	var cell = ctx.food_tiles.local_to_map(pos_comp.value)
	if not ctx.cell_to_entity.has(cell):
		return false

	var plant_id = ctx.cell_to_entity[cell]
	return harvest_entity(ctx, entity, plant_id)


func harvest_entity(ctx: GameContext, entity: int, plant_id: int) -> bool:
	return ctx.plant_system.harvest(ctx, plant_id, entity)


func eat(ctx: GameContext, entity: int, eat_amount: float = 50.0) -> bool:
	var inventory = ctx.registry.get_component(entity, InventoryComponent)
	var hunger = ctx.registry.get_component(entity, HungerComponent)
	if inventory == null or hunger == null:
		return false

	if inventory.food > 0 and hunger.value < 150:
		inventory.food -= 1
		hunger.value += eat_amount
		return true

	return false
