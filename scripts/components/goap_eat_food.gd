class_name GoapEatFood
extends GoapAction

var eaten := false
var eat_amount := 40


func _init():
	name = "eat_food"

	preconditions = {
		"has_food": true
	}

	effects = {
		"hungry": false
	}


func perform(world, entity):

	if eaten:
		return

	var hunger = world.get_component(entity, HungerComponent)
	var inventory = world.get_component(entity, InventoryComponent)

	if hunger == null or inventory == null:
		return

	if inventory.food <= 0:
		return

	inventory.food -= 1
	hunger.value += eat_amount

	eaten = true


func is_done(world, entity):
	return eaten


func reset():
	eaten = false
