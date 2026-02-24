class_name GoapEatFood
extends GoapAction

func _init():
	name = "eat_food"
	cost = 1.0

	preconditions = {
		"has_food": true,
		"hungry": true
	}

	effects = {
		"hungry": false,
		"has_food": false
	}
