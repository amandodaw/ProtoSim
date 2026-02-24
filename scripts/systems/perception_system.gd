class_name PerceptionSystem

func update(world: World, delta: float):

	for entity in world.query([PerceptionComponent, PositionComponent, VisiblePlantsComponent]):

		var perception = world.get_component(entity, PerceptionComponent)
		var pos = world.get_component(entity, PositionComponent)
		var visible = world.get_component(entity, VisiblePlantsComponent)

		# reset resultados
		visible.plants.clear()
		visible.closest = -1
		visible.closest_distance = INF

		# buscar plantas maduras
		for plant in world.query([PlantGrowComponent, PositionComponent]):

			var grow = world.get_component(plant, PlantGrowComponent)
			if grow.stage < grow.max_stage:
				continue

			var plant_pos = world.get_component(plant, PositionComponent)

			var dist = pos.value.distance_to(plant_pos.value)

			if dist > perception.radius:
				continue

			visible.plants.append(plant)

			if dist < visible.closest_distance:
				visible.closest_distance = dist
				visible.closest = plant
