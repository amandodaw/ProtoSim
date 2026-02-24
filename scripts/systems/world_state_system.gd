class_name WorldStateSystem

var reach_distance := 20.0

func update(world: World, delta: float):

	for entity in world.query([
		AgentWorldStateComponent,
		HungerComponent,
		InventoryComponent,
		VisiblePlantsComponent,
		PositionComponent
	]):

		var state = world.get_component(entity, AgentWorldStateComponent)
		var hunger = world.get_component(entity, HungerComponent)
		var inventory = world.get_component(entity, InventoryComponent)
		var visible = world.get_component(entity, VisiblePlantsComponent)
		var pos = world.get_component(entity, PositionComponent)

		# --------------------------------
		# ESTADO INTERNO
		# --------------------------------
		state.hungry = hunger.value < 50
		state.has_food = inventory.food > 0

		# --------------------------------
		# PERCEPCIÓN
		# --------------------------------

		state.food_visible = visible.closest != -1
		state.food_reachable = false

		if visible.closest != -1:
			var plant_pos = world.get_component(
				visible.closest,
				PositionComponent
			)

			if plant_pos != null:
				var dist = pos.value.distance_to(plant_pos.value)
				state.food_reachable = dist < reach_distance
