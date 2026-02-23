class_name HungerSystem

func update(entity_data):
	entity_data.hunger -= entity_data.hunger_variable
	if entity_data.hunger <= 0:
		entity_data.hunger = entity_data.max_hunger
		entity_data.health -= 1
	
	
