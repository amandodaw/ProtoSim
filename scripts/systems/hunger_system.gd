class_name HungerSystem

func update(ctx: GameContext, delta: float):
	for entity in ctx.registry.query([HungerComponent]):
		var hunger = ctx.registry.get_component(entity, HungerComponent)
		hunger.value -= hunger.rate * delta
		if hunger.value <= 0:
			hunger.value = hunger.max_hunger
			ctx.registry.get_component(entity, HealthComponent).health -= 1
