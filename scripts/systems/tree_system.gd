class_name TreeSystem

const DomainEventsRef = preload("res://scripts/domain/events/events.gd")


func update(ctx: GameContext, delta: float):
	for tree_id in ctx.game_state.trees.keys():
		var tree = ctx.game_state.get_tree(tree_id)
		if tree == null or tree.stage == tree.max_stage:
			continue

		tree.growth_timer += delta
		if tree.growth_timer >= tree.time_to_next_stage:
			tree.growth_timer = 0.0
			tree.stage += 1
			ctx.event_bus.publish(DomainEventsRef.tree_grown(tree.id, tree.cell, tree.stage))


func chop(ctx: GameContext, tree_id: int, harvester: int) -> bool:
	var tree = ctx.game_state.get_tree(tree_id)
	if tree == null:
		return false

	if tree.stage < 1:
		return false

	var wood_gained = 1 if tree.stage >= tree.max_stage else 0
	ctx.game_state.remove_tree(tree_id)
	ctx.registry.destroy_entity(tree_id)
	ctx.event_bus.publish(DomainEventsRef.tree_chopped(tree_id, tree.cell, harvester, wood_gained))

	if wood_gained > 0:
		var agent = ctx.game_state.get_agent(harvester)
		if agent != null:
			agent.wood += wood_gained

		var inv = ctx.registry.get_component(harvester, InventoryComponent)
		if inv != null:
			if agent != null:
				inv.wood = agent.wood
			else:
				inv.wood += wood_gained

	return true
