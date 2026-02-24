extends RefCounted

const GameStateRef = preload("res://scripts/domain/state/game_state.gd")
const EventBusRef = preload("res://scripts/domain/events/domain_event_bus.gd")


func run() -> bool:
	var game_state = GameStateRef.new()
	var hunger := HungerComponent.new()
	var inventory := InventoryComponent.new()
	var health := HealthComponent.new()
	game_state.register_agent(1, hunger, inventory, health)

	var ctx := GameContext.new()
	ctx.game_state = game_state
	ctx.registry = EcsRegistry.new()
	ctx.event_bus = EventBusRef.new()
	ctx.agent_actions = AgentActions.new()

	ctx.registry.add(1, hunger)
	ctx.registry.add(1, inventory)

	inventory.food = 1
	var agent = game_state.get_agent(1)
	agent.food = 1
	agent.hunger = 10.0

	var ate = ctx.agent_actions.eat(ctx, 1, 20.0)
	if not ate:
		return false

	return agent.food == 0 and int(agent.hunger) == 30
