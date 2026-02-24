class_name GoapActionsRegistry

static func get_default_actions() -> Array:
	return [
		GoapMoveToFood.new(),
		GoapHarvestFood.new(),
		GoapEatFood.new()
	]
