class_name ActionSystem

func update(world:World, delta):
	for entity in world.query([IntentComponent]):
		var intent = world.get_component(entity, IntentComponent)
		if intent.pick:
			pick_food(world, entity)
			intent.pick = false
		if intent.eat:
			eat_food(world, entity)
			intent.eat = false
		

func pick_food(world : World, entity : int):

	var pos = world.get_component(entity, PositionComponent).value
	var cell = world.food_tiles.local_to_map(pos)

	if not world.cell_to_entity.has(cell):
		return

	var plant_id = world.cell_to_entity[cell]

	world.plant_system.harvest(world, plant_id, entity)

func eat_food(world: World, entity : int):
	var inventory = world.get_component(entity, InventoryComponent)
	var hunger = world.get_component(entity, HungerComponent)
	if inventory.food >0 && hunger.value < 150:
		inventory.food -= 1
		hunger.value += 50
