class_name GoapMoveToFood
extends GoapAction

var target_plant = null
var reached := false
var arrive_distance := 6.0


func _init():
	name = "move_to_food"

	preconditions = {
		"food_visible": true
	}

	effects = {
		"food_reachable": true
	}


func perform(world, entity):

	if reached:
		return

	var perception = world.get_component(entity, PerceptionComponent)
	var visible_plants = world.get_component(entity, VisiblePlantsComponent)
	var position = world.get_component(entity, PositionComponent)
	var movement = world.get_component(entity, MovementComponent)

	if perception == null or visible_plants.plants.is_empty():
		return

	# elegir objetivo si no hay
	if target_plant == null:
		target_plant = visible_plants.plants[0]

	if not world.entity_exists(target_plant):
		target_plant = null
		return

	var plant_pos = world.get_component(target_plant, PositionComponent)
	if plant_pos == null:
		return

	var dist = position.value.distance_to(plant_pos.value)

	if dist <= arrive_distance:
		reached = true
		movement.direction = Vector2.ZERO
	else:
		var dir : Vector2 = (plant_pos.value - position.value)
		movement.direction = dir.normalized()


func is_done(world, entity):
	return reached


func reset():
	reached = false
	target_plant = null
