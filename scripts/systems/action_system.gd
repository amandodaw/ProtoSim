class_name ActionSystem

func update(ctx: GameContext, delta: float):
	for entity in ctx.registry.query([IntentComponent]):
		var intent = ctx.registry.get_component(entity, IntentComponent)
		if intent.pick:
			pick_food(ctx, entity)
			intent.pick = false
		if intent.eat:
			eat_food(ctx, entity)
			intent.eat = false
		if intent.chop:
			chop_tree(ctx, entity)
			intent.chop = false
		

func pick_food(ctx: GameContext, entity: int):
	ctx.agent_actions.harvest(ctx, entity)

func eat_food(ctx: GameContext, entity: int):
	ctx.agent_actions.eat(ctx, entity)


func chop_tree(ctx: GameContext, entity: int):
	ctx.agent_actions.chop(ctx, entity)
