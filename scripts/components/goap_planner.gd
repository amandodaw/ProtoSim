class_name GoapPlanner


func plan(initial_state: Dictionary, goal: Dictionary, actions: Array) -> Array:

	var frontier : Array = []
	var visited := {}
	visited[state_key(initial_state)] = true
	frontier.append({
		"state": initial_state,
		"plan": []
	})

	while not frontier.is_empty():

		var node = frontier.pop_front()
		var current_state : Dictionary = node["state"]
		var current_plan : Array = node["plan"]

		if goal_reached(current_state, goal):
			return current_plan

		for action in actions:

			if not check_preconditions(current_state, action.preconditions):
				continue

			var new_state = apply_effects(current_state, action.effects)
			var new_state_key = state_key(new_state)
			if visited.has(new_state_key):
				continue
			visited[new_state_key] = true
			var new_plan = current_plan.duplicate()
			new_plan.append(action)

			frontier.append({
				"state": new_state,
				"plan": new_plan
			})

	return []


func state_key(state: Dictionary) -> String:
	var keys = state.keys()
	keys.sort()
	var parts: Array = []
	for key in keys:
		parts.append("%s=%s" % [str(key), str(state[key])])
	return "|".join(parts)


func goal_reached(state: Dictionary, goal: Dictionary) -> bool:
	for key in goal:
		if state.get(key) != goal[key]:
			return false
	return true


func check_preconditions(state: Dictionary, preconditions: Dictionary) -> bool:
	for key in preconditions:
		if state.get(key) != preconditions[key]:
			return false
	return true


func apply_effects(state: Dictionary, effects: Dictionary) -> Dictionary:
	var new_state = state.duplicate()
	for key in effects:
		new_state[key] = effects[key]
	return new_state
