class_name ActionSystem

func update(world:World, delta):
	for entity in world.query([IntentComponent]):
		if world.get_component(entity, IntentComponent).pick:
			pick_food(world, entity)
		if world.get_component(entity, IntentComponent).eat:
			eat_food(world, entity)
		

func pick_food(world : World, entity : int):
	if world.food_tiles.get_cell_source_id(world.food_tiles.local_to_map(world.get_component(entity, PositionComponent).value))!= -1:
		world.food_tiles.erase_cell(world.food_tiles.local_to_map(world.get_component(entity, PositionComponent).value))
		world.get_component(entity, InventoryComponent).food += 1
		print("food picked")

func eat_food(world: World, entity : int):
	if world.get_component(entity, InventoryComponent).food >0 && world.get_component(entity, HungerComponent).hunger < 150:
		world.get_component(entity, InventoryComponent).food -= 1
		world.get_component(entity, HungerComponent).hunger += 50
