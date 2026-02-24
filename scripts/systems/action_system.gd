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
		

func pick_food(world: World, entity: int):

	var pos = world.get_component(entity, PositionComponent).value
	var cell = world.food_tiles.local_to_map(pos)

	if not world.cell_to_entity.has(cell):
		return

	var plant_id = world.cell_to_entity[cell]
	var grow = world.get_component(plant_id, PlantGrowComponent)

	if grow.stage < grow.max_stage:
		print("plant not mature yet")
		return

	world.food_tiles.erase_cell(cell)
	world.cell_to_entity.erase(cell)
	world.destroy_entity(plant_id)
	
	world.get_component(entity, InventoryComponent).food += 1

func eat_food(world: World, entity : int):
	var inventory = world.get_component(entity, InventoryComponent)
	var hunger = world.get_component(entity, HungerComponent)
	if inventory.food >0 && hunger.value < 150:
		inventory.food -= 1
		hunger.value += 50
