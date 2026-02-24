extends RefCounted


func run() -> bool:
	var planner := GoapPlanner.new()
	var actions = GoapActionsRegistry.get_default_actions()
	var state = {
		"hungry": true,
		"has_food": false,
		"food_visible": true,
		"food_reachable": false
	}
	var goal = {"hungry": false}
	var plan = planner.plan(state, goal, actions)
	return not plan.is_empty()
