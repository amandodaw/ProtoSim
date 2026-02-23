class_name HungerSystem

func update(world : World, delta):
	for entity in world.query([HungerComponent]):
		world.get_component(entity, HungerComponent).hunger -= world.get_component(entity, HungerComponent).rate*delta
		if world.get_component(entity, HungerComponent).hunger <= 0:
			world.get_component(entity, HungerComponent).hunger = world.get_component(entity, HungerComponent).max_hunger
			world.get_component(entity, HealthComponent).health -= 1
