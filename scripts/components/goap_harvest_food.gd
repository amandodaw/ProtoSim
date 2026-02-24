class_name GoapHarvestFood
extends GoapAction

func _init():
	name = "harvest_food"
	cost = 1.0

	preconditions = {
		"food_reachable": true,
		"has_food": false
	}

	effects = {
		"has_food": true
	}
