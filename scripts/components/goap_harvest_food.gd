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


func perform(world, entity):

	if harvested:
		return

	var perception = world.get_component(entity, PerceptionComponent)
	var visible_plants = world.get_component(entity, VisiblePlantsComponent)
	var position = world.get_component(entity, PositionComponent)
	var inventory = world.get_component(entity, InventoryComponent)

	if perception == null or visible_plants.plants.is_empty():
		return

	if target_plant == null:
		target_plant = visible_plants.plants[0]

	if not world.entity_exists(target_plant):
		target_plant = null
		return

	var plant_pos = world.get_component(target_plant, PositionComponent)
	if plant_pos == null:
		return

	var dist = position.value.distance_to(plant_pos.value)

	if dist > harvest_distance:
		return

	# recoger planta
	world.destroy_entity(target_plant)
	inventory.food += 1

	harvested = true


func is_done(world, entity):
	return harvested


func reset():
	harvested = false
	target_plant = null
