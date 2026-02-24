class_name GoapPlannerSystem

var planner := GoapPlanner.new()

func update(world: World, delta: float):

	for entity in world.query([
		AgentWorldStateComponent,
		GoapPlanComponent
	]):

		var state_comp = world.get_component(entity, AgentWorldStateComponent)
		var plan_comp = world.get_component(entity, GoapPlanComponent)

		if plan_comp.actions.is_empty():

			var state = world_state_to_dict(state_comp)
			var goal = { "hungry": false }

			var actions = GoapActionsRegistry.get_default_actions()

			var plan = planner.plan(state, goal, actions)

			if not plan.is_empty():
				plan_comp.actions = plan
				plan_comp.current_index = 0
				print("NEW PLAN:")
				for a in plan:
					print(a.name)

static func world_state_to_dict(state) -> Dictionary:
	return {
		"hungry": state.hungry,
		"has_food": state.has_food,
		"food_visible": state.food_visible,
		"food_reachable": state.food_reachable
	}
