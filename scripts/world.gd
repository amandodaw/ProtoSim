extends Node2D
class_name World

var player_scene : PackedScene = load("res://scenes/player.tscn")
#var food_scene : PackedScene = load("res://scenes/food.tscn")
@onready var map_tiles = $Tilemaps/GroundLayer
@onready var food_tiles = $Tilemaps/FoodLayer
@onready var ui = $CanvasLayer

var input_system : InputSystem
var spawn_system : SpawnSystem
var hunger_system : HungerSystem
var plant_system : PlantSystem
var action_system : ActionSystem
var physics_system : PhysicsSystem

# =========================================================
# ENTIDADES
# =========================================================

var _next_entity_id : int = 0

func create_entity() -> int:
	var id = _next_entity_id
	_next_entity_id += 1
	return id

# =========================
# COMPONENTES
# =========================
var components := {}

func add(entity: int, component) -> void:
	var type = component.get_script()
	
	if not components.has(type):
		components[type] = {}
	components[type][entity] = component

func get_component(entity: int, type):
	if components.has(type) and components[type].has(entity):
		return components[type][entity]
	return

func has_component(entity: int, type) -> bool:
	return components.has(type) and components[type].has(entity)

func remove_component(entity: int, type) -> void:
	if components.has(type):
		components[type].erase(entity)

func destroy_entity(entity: int) -> void:
	for type in components.keys():
		components[type].erase(entity)

# =========================================================
# QUERY
# devuelve entidades que tienen TODOS los tipos pedidos
# =========================================================

func query(required_types: Array) -> Array:
	
	if required_types.is_empty():
		return []
	
	var first_type = required_types[0]
	if not components.has(first_type):
		return []
	
	var result := []
	
	for entity in components[first_type].keys():
		
		var valid = true
		
		for t in required_types:
			if not has_component(entity, t):
				valid = false
				break
		
		if valid:
			result.append(entity)
	
	return result
	
# =========================
# SISTEMAS
# =========================
var systems : Array = []

func register_system(system) -> void:
	systems.append(system)

func _ready() -> void:
	ui.world = self
	#Vincular sistemas. Revisar
	#action_system.food_tilemap = food_tiles
	#input_system.action_system = action_system
	#ui.player_data = player_data
	input_system = InputSystem.new()
	spawn_system = SpawnSystem.new()
	hunger_system = HungerSystem.new()
	plant_system = PlantSystem.new()
	action_system = ActionSystem.new()
	physics_system = PhysicsSystem.new()

	register_system(input_system)
	register_system(spawn_system)
	register_system(hunger_system)
	register_system(plant_system)
	register_system(action_system)
	register_system(physics_system)

	
	var player_id = create_entity()
	ui.player_id = player_id
	var player_pos = PositionComponent.new()
	player_pos.value = get_viewport_rect().size / 2
	add(player_id, player_pos)
	add(player_id, HealthComponent.new())
	add(player_id, HungerComponent.new())
	add(player_id, InventoryComponent.new())
	add(player_id, MovementComponent.new())
	add(player_id, InputComponent.new())
	add(player_id, IntentComponent.new())
	player = player_scene.instantiate()
	var body_comp = CharacterBodyComponent.new()
	body_comp.body = player
	add(player_id, body_comp)
	add_child(player)

# =========================
# LOOP PRINCIPAL ECS
# =========================
func _physics_process(delta: float) -> void:
	for system in systems:
		system.update(self, delta)

var player 
var cell_to_entity : Dictionary = {}
