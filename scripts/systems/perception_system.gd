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

		# buscar plantas maduras
		for plant in ctx.registry.query([PlantGrowComponent, PositionComponent]):

			var grow = ctx.registry.get_component(plant, PlantGrowComponent)
			if grow.stage < grow.max_stage:
				continue

			var plant_pos = ctx.registry.get_component(plant, PositionComponent)

			var dist = pos.value.distance_to(plant_pos.value)

			if dist > perception.radius:
				continue

			visible.plants.append(plant)

			if dist < visible.closest_distance:
				visible.closest_distance = dist
				visible.closest = plant
