class_name HungerSystem

const DomainEventsRef = preload("res://scripts/domain/events/events.gd")

func update(ctx: GameContext, delta: float):
	for entity in ctx.game_state.agents.keys():
		var agent = ctx.game_state.get_agent(entity)
		if agent == null:
			continue

		agent.hunger -= agent.hunger_rate * delta
		if agent.hunger <= 0:
			agent.hunger = agent.max_hunger
			agent.health -= 1

		var hunger_comp = ctx.registry.get_component(entity, HungerComponent)
		if hunger_comp != null:
			hunger_comp.value = agent.hunger

		var health_comp = ctx.registry.get_component(entity, HealthComponent)
		if health_comp != null:
			health_comp.health = agent.health

		ctx.event_bus.publish(DomainEventsRef.hunger_changed(entity, agent.hunger, agent.health))
