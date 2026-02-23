class_name AiSystem

var action_system : ActionSystem

func check_status(entity):
	match entity.state:
		"Hungry":
			if entity.food > 0:
				action_system.eat_food(entity)
			else:
				look_for_food()
	if entity.hunger <= 50:
		entity.state = "Hungry"
	

func look_for_food():
	pass
