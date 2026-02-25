class_name GoapHarvestFood
extends GoapAction

var harvested := false
var target_plant = null
var harvest_distance := 6.0


func _init():
	name = "harvest_food"

	preconditions = {
		"food_reachable": true
	}

	effects = {
		"has_food": true
	}


func perform(ctx: GameContext, entity: int):

	if harvested:
		return

	var visible_plants = ctx.registry.get_component(entity, VisiblePlantsComponent)
	var position = ctx.registry.get_component(entity, PositionComponent)

	if visible_plants == null or visible_plants.plants.is_empty():
		target_plant = null
		return

	if target_plant == null:
		target_plant = visible_plants.closest

	if target_plant == -1:
		target_plant = null
		return

	if not ctx.game_state.has_plant(target_plant):
		target_plant = null
		return

	var plant = ctx.game_state.get_plant(target_plant)
	if plant == null:
		return

	var dist = position.value.distance_to(plant.position)

	if dist > harvest_distance:
		return

	if ctx.agent_actions.harvest_entity(ctx, entity, target_plant):
		harvested = true


func is_done(ctx: GameContext, entity: int):
	return harvested


func reset():
	harvested = false
	target_plant = null
