class_name DomainEvents


static func plant_spawned(plant_id: int, cell: Vector2i, stage: int) -> Dictionary:
	return {
		"type": "PlantSpawned",
		"plant_id": plant_id,
		"cell": cell,
		"stage": stage
	}


static func plant_grown(plant_id: int, cell: Vector2i, stage: int) -> Dictionary:
	return {
		"type": "PlantGrown",
		"plant_id": plant_id,
		"cell": cell,
		"stage": stage
	}


static func plant_harvested(plant_id: int, cell: Vector2i, harvester: int) -> Dictionary:
	return {
		"type": "PlantHarvested",
		"plant_id": plant_id,
		"cell": cell,
		"harvester": harvester
	}


static func food_eaten(entity: int, amount: float, hunger_after: float, food_after: int) -> Dictionary:
	return {
		"type": "FoodEaten",
		"entity": entity,
		"amount": amount,
		"hunger_after": hunger_after,
		"food_after": food_after
	}


static func hunger_changed(entity: int, hunger: float, health: int) -> Dictionary:
	return {
		"type": "HungerChanged",
		"entity": entity,
		"hunger": hunger,
		"health": health
	}


static func tree_spawned(tree_id: int, cell: Vector2i, stage: int) -> Dictionary:
	return {
		"type": "TreeSpawned",
		"tree_id": tree_id,
		"cell": cell,
		"stage": stage
	}


static func tree_grown(tree_id: int, cell: Vector2i, stage: int) -> Dictionary:
	return {
		"type": "TreeGrown",
		"tree_id": tree_id,
		"cell": cell,
		"stage": stage
	}


static func tree_chopped(tree_id: int, cell: Vector2i, harvester: int, wood_gained: int) -> Dictionary:
	return {
		"type": "TreeChopped",
		"tree_id": tree_id,
		"cell": cell,
		"harvester": harvester,
		"wood_gained": wood_gained
	}
