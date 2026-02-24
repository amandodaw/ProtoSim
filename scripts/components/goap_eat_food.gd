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


func perform(ctx: GameContext, entity: int):

	if eaten:
		return

	var hunger = ctx.registry.get_component(entity, HungerComponent)
	var inventory = ctx.registry.get_component(entity, InventoryComponent)

	if hunger == null or inventory == null:
		return

	if inventory.food <= 0:
		return

	if ctx.agent_actions.eat(ctx, entity, eat_amount):
		eaten = true


func is_done(ctx: GameContext, entity: int):
	return eaten


func reset():
	eaten = false
