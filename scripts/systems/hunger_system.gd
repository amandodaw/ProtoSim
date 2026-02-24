class_name HungerSystem

func update(world : World, delta):
	for entity in world.query([HungerComponent]):
		var hunger = world.get_component(entity, HungerComponent)
		hunger.value -= hunger.rate*delta
		if hunger.value <= 0:
			hunger.value = hunger.max_hunger
			world.get_component(entity, HealthComponent).health -= 1
