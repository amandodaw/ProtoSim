class_name PerceptionSystem

func update(ctx: GameContext, delta: float):

	for entity in ctx.registry.query([PerceptionComponent, PositionComponent, VisiblePlantsComponent]):

		var perception = ctx.registry.get_component(entity, PerceptionComponent)
		var pos = ctx.registry.get_component(entity, PositionComponent)
		var visible = ctx.registry.get_component(entity, VisiblePlantsComponent)

		# reset resultados
		visible.plants.clear()
		visible.closest = -1
		visible.closest_distance = INF

		# buscar plantas maduras en estado de dominio
		for plant_id in ctx.game_state.plants.keys():
			var plant = ctx.game_state.get_plant(plant_id)
			if plant == null or plant.stage < plant.max_stage:
				continue

			var dist = pos.value.distance_to(plant.position)

			if dist > perception.radius:
				continue

			visible.plants.append(plant_id)

			if dist < visible.closest_distance:
				visible.closest_distance = dist
				visible.closest = plant
