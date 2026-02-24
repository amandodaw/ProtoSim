class_name GoapPlannerSystem

var planner := GoapPlanner.new()

func update(ctx: GameContext, delta: float):

	for entity in ctx.registry.query([
		AgentWorldStateComponent,
		GoapPlanComponent
	]):

		var state_comp = ctx.registry.get_component(entity, AgentWorldStateComponent)
		var plan_comp = ctx.registry.get_component(entity, GoapPlanComponent)

		if plan_comp.plan.is_empty():

			var state = world_state_to_dict(state_comp)
			var goal = { "hungry": false }
			var actions = GoapActionsRegistry.get_default_actions()

			var plan = planner.plan(state, goal, actions)

			for action in plan:
				action.reset()
				
			if not plan.is_empty():
				plan_comp.plan = plan
				plan_comp.current_index = 0

			var names := []
			for a in plan:
				names.append(a.name)

static func world_state_to_dict(state) -> Dictionary:
	return {
		"hungry": state.hungry,
		"has_food": state.has_food,
		"food_visible": state.food_visible,
		"food_reachable": state.food_reachable
	}
