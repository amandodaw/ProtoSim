class_name GameState

const TreeStateRef = preload("res://scripts/domain/state/tree_state.gd")

var agents: Dictionary = {}
var plants: Dictionary = {}
var plant_by_cell: Dictionary = {}
var trees: Dictionary = {}
var tree_by_cell: Dictionary = {}


func register_agent(entity: int, hunger: HungerComponent, inventory: InventoryComponent, health: HealthComponent) -> void:
	var state := AgentState.new()
	state.hunger = hunger.value
	state.max_hunger = hunger.max_hunger
	state.hunger_rate = hunger.rate
	state.food = inventory.food
	state.wood = inventory.wood
	state.health = health.health
	agents[entity] = state


func has_agent(entity: int) -> bool:
	return agents.has(entity)


func get_agent(entity: int) -> AgentState:
	if agents.has(entity):
		return agents[entity]
	return null


func add_plant(plant_id: int, cell: Vector2i, position: Vector2, stage: int = 0, max_stage: int = 2, time_to_next_stage: float = 5.0) -> PlantState:
	var state := PlantState.new()
	state.id = plant_id
	state.cell = cell
	state.position = position
	state.stage = stage
	state.max_stage = max_stage
	state.time_to_next_stage = time_to_next_stage
	plants[plant_id] = state
	plant_by_cell[cell] = plant_id
	return state


func has_plant(plant_id: int) -> bool:
	return plants.has(plant_id)


func get_plant(plant_id: int) -> PlantState:
	if plants.has(plant_id):
		return plants[plant_id]
	return null


func get_plant_id_by_cell(cell: Vector2i) -> int:
	if plant_by_cell.has(cell):
		return plant_by_cell[cell]
	return -1


func remove_plant(plant_id: int) -> PlantState:
	if not plants.has(plant_id):
		return null
	var state: PlantState = plants[plant_id]
	plants.erase(plant_id)
	plant_by_cell.erase(state.cell)
	return state


func add_tree(tree_id: int, cell: Vector2i, position: Vector2, stage: int = 0, max_stage: int = 2, time_to_next_stage: float = 8.0):
	var state = TreeStateRef.new()
	state.id = tree_id
	state.cell = cell
	state.position = position
	state.stage = stage
	state.max_stage = max_stage
	state.time_to_next_stage = time_to_next_stage
	trees[tree_id] = state
	tree_by_cell[cell] = tree_id
	return state


func has_tree(tree_id: int) -> bool:
	return trees.has(tree_id)


func get_tree(tree_id: int):
	if trees.has(tree_id):
		return trees[tree_id]
	return null


func get_tree_id_by_cell(cell: Vector2i) -> int:
	if tree_by_cell.has(cell):
		return tree_by_cell[cell]
	return -1


func remove_tree(tree_id: int):
	if not trees.has(tree_id):
		return null
	var state = trees[tree_id]
	trees.erase(tree_id)
	tree_by_cell.erase(state.cell)
	return state
