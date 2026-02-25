class_name GoapMoveToFood
extends GoapAction

const GameplayConstantsRef = preload("res://scripts/core/gameplay_constants.gd")

var target_plant = null
var reached := false
var arrive_distance := GameplayConstantsRef.FOOD_INTERACTION_DISTANCE


func _init():
	name = "move_to_food"

	preconditions = {
		"food_visible": true
	}

	effects = {
		"food_reachable": true
	}


func perform(ctx: GameContext, entity: int):

	if reached:
		return

	var visible_plants = ctx.registry.get_component(entity, VisiblePlantsComponent)
	var position = ctx.registry.get_component(entity, PositionComponent)
	var movement = ctx.registry.get_component(entity, MovementComponent)

	if visible_plants == null or visible_plants.plants.is_empty():
		target_plant = null
		if movement != null:
			movement.direction = Vector2.ZERO
		return

	# elegir objetivo si no hay
	if target_plant == null:
		target_plant = visible_plants.closest

	if target_plant == -1:
		target_plant = null
		if movement != null:
			movement.direction = Vector2.ZERO
		return

	if not ctx.game_state.has_plant(target_plant):
		target_plant = null
		if movement != null:
			movement.direction = Vector2.ZERO
		return

	var plant = ctx.game_state.get_plant(target_plant)
	if plant == null:
		if movement != null:
			movement.direction = Vector2.ZERO
		return

	var dist = position.value.distance_to(plant.position)

	if dist <= arrive_distance:
		reached = true
		movement.direction = Vector2.ZERO
	else:
		var dir : Vector2 = (plant.position - position.value)
		movement.direction = dir.normalized()


func is_done(ctx: GameContext, entity: int):
	return reached


func reset():
	reached = false
	target_plant = null
