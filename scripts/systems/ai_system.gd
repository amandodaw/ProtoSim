class_name AISystem

var harvest_distance := 6.0

func update(world: World, delta: float):

	for entity in world.query([
		PerceptionComponent,
		VisiblePlantsComponent,
		PositionComponent,
		IntentComponent,
		MovementComponent,
		AIComponent
	]):

		var visible = world.get_component(entity, VisiblePlantsComponent)
		var pos = world.get_component(entity, PositionComponent)
		var intent = world.get_component(entity, IntentComponent)
		var move = world.get_component(entity, MovementComponent)

		# reset
		move.direction = Vector2.ZERO
		intent.pick = false

		if visible.closest == -1:
			continue

		var plant_pos = world.get_component(
			visible.closest,
			PositionComponent
		)
		if plant_pos==null:
			continue

		var dir : Vector2 = plant_pos.value - pos.value
		var dist = dir.length()

		if dist < harvest_distance:
			intent.pick = true
		else:
			move.direction = dir.normalized()
