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
			_reset_stuck_tracking(plan_comp)
			continue

		var action = plan_comp.plan[plan_comp.current_index]
		if plan_comp.last_action_index != plan_comp.current_index:
			_reset_stuck_tracking(plan_comp)
			plan_comp.last_action_index = plan_comp.current_index

		# ejecutar acción
		action.perform(ctx, entity)

		# comprobar si terminó
		if action.is_done(ctx, entity):
			plan_comp.current_index += 1
			_reset_stuck_tracking(plan_comp)
			continue

		_track_stuck_progress(ctx, entity, plan_comp, delta)


func _track_stuck_progress(ctx: GameContext, entity: int, plan_comp: GoapPlanComponent, delta: float) -> void:
	var position = ctx.registry.get_component(entity, PositionComponent)
	if position == null:
		return

	if not plan_comp.has_last_position:
		plan_comp.last_position = position.value
		plan_comp.has_last_position = true
		plan_comp.stuck_time = 0.0
		return

	var moved_distance = plan_comp.last_position.distance_to(position.value)
	if moved_distance <= plan_comp.stuck_epsilon:
		plan_comp.stuck_time += delta
	else:
		plan_comp.stuck_time = 0.0

	plan_comp.last_position = position.value

	if plan_comp.stuck_time >= plan_comp.stuck_timeout:
		plan_comp.plan.clear()
		plan_comp.current_index = 0
		_reset_stuck_tracking(plan_comp)


func _reset_stuck_tracking(plan_comp: GoapPlanComponent) -> void:
	plan_comp.stuck_time = 0.0
	plan_comp.has_last_position = false
	plan_comp.last_position = Vector2.ZERO
	plan_comp.last_action_index = -1
