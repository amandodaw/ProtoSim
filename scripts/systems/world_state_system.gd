class_name WorldStateSystem

var reach_distance := 20.0

func update(ctx: GameContext, delta: float):

	for entity in ctx.registry.query([
		AgentWorldStateComponent,
		VisiblePlantsComponent,
		PositionComponent
	]):

		var state = ctx.registry.get_component(entity, AgentWorldStateComponent)
		var agent = ctx.game_state.get_agent(entity)
		var visible = ctx.registry.get_component(entity, VisiblePlantsComponent)
		var pos = ctx.registry.get_component(entity, PositionComponent)
		if agent == null:
			continue

		# --------------------------------
		# ESTADO INTERNO
		# --------------------------------
		state.hungry = agent.hunger < 50
		state.has_food = agent.food > 0

		# --------------------------------
		# PERCEPCIÓN
		# --------------------------------

		state.food_visible = visible.closest != -1
		state.food_reachable = false

		if visible.closest != -1:
			var plant = ctx.game_state.get_plant(visible.closest)

			if plant != null:
				var dist = pos.value.distance_to(plant.position)
				state.food_reachable = dist < reach_distance
