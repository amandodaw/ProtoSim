class_name GoapExecutionSystem


func update(ctx: GameContext, delta: float):

	for entity in ctx.registry.query([
		GoapPlanComponent,
		IntentComponent
	]):

		var plan_comp = ctx.registry.get_component(entity, GoapPlanComponent)

		# no plan → nada que hacer
		if plan_comp.plan.is_empty():
			continue

		# si índice fuera de rango → plan terminado
		if plan_comp.current_index >= plan_comp.plan.size():
			plan_comp.plan.clear()
			plan_comp.current_index = 0
			continue

		var action = plan_comp.plan[plan_comp.current_index]

		# ejecutar acción
		action.perform(ctx, entity)

		# comprobar si terminó
		if action.is_done(ctx, entity):
			plan_comp.current_index += 1
