class_name  PlantSystem

var plant_tiles = {
	0: Vector2i(2, 1), # semilla
	1: Vector2i(5, 1), # creciendo
	2: Vector2i(5, 2)  # madura
}

func update(ctx: GameContext, delta: float):
	for entity in ctx.registry.query([PlantGrowComponent]):
		var comp = ctx.registry.get_component(entity, PlantGrowComponent)
		if comp.stage == comp.max_stage:
			continue
		comp.growth_timer += delta
		if comp.growth_timer >= comp.time_to_next_stage:
			comp.growth_timer = 0.0
			comp.stage += 1
			var new_tile = plant_tiles[comp.stage]
			ctx.food_tiles.set_cell(comp.cell, 0, new_tile)
			print("la planta ha crecido al stage: ", comp.stage)
			


func harvest(ctx: GameContext, plant_entity: int, harvester: int) -> bool:

	var grow = ctx.registry.get_component(plant_entity, PlantGrowComponent)
	if grow == null:
		return false

	if grow.stage < grow.max_stage:
		return false

	# borrar tile
	ctx.food_tiles.erase_cell(grow.cell)

	# borrar mapping
	ctx.cell_to_entity.erase(grow.cell)

	# destruir entidad planta
	ctx.registry.destroy_entity(plant_entity)

	# dar comida al recolector
	var inv = ctx.registry.get_component(harvester, InventoryComponent)
	inv.food += 1

	return true
