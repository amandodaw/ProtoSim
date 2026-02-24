class_name GoapMoveToFood
extends GoapAction

func _init():
	name = "move_to_food"
	cost = 1.0

	preconditions = {
		"food_visible": true,
		"food_reachable": false
	}

	effects = {
		"food_reachable": true
	}
