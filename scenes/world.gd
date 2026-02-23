extends Node2D
class_name World

var player_scene : PackedScene = load("res://scenes/player.tscn")
var food_scene : PackedScene = load("res://scenes/food.tscn")
var food_tile : Vector2i = Vector2i(5, 2)
@onready var map_tiles = $Tilemaps/GroundLayer
@onready var food_tiles = $Tilemaps/FoodLayer
@onready var ui = $CanvasLayer

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
	#Vincular sistemas. Revisar
	#action_system.food_tilemap = food_tiles
	#input_system.action_system = action_system
	#ui.player_data = player_data
	var input_system := InputSystem.new()
	var hunger_system := HungerSystem.new()
	var action_system := ActionSystem.new()
	register_system(input_system)
	register_system(hunger_system)
	register_system(action_system)
	
	var player_id = create_entity()
	var player_pos = PositionComponent.new()
	player_pos.value = get_viewport_rect().size / 2
	add(player_id, player_pos)
	add(player_id, HealthComponent.new())
	add(player_id, HungerComponent.new())
	add(player_id, InventoryComponent.new())
	add(player_id, MovementComponent.new())
	player = player_scene.instantiate()
	add_child(player)

# =========================
# LOOP PRINCIPAL ECS
# =========================
func _process(delta):
	time_acumulator(delta)
	for system in systems:
		system.update(self, delta)

var player 

# =========================
# TIMER
# =========================
@export var tick_duration := 1.0   # 1 tick = 1 segundo
var accumulator := 0.0
var food_tick_counter := 0
const FOOD_INTERVAL := 5


func time_acumulator(delta):
	accumulator += delta
	while accumulator >= tick_duration:
		simulation_tick()
		accumulator -= tick_duration

func simulation_tick():
	
	food_tick_counter += 1
	
	if food_tick_counter >= FOOD_INTERVAL:
		spawn_food_random()
		food_tick_counter = 0
	#hunger_system.update(player_data)
	

func spawn_food_random():

	var cells = map_tiles.get_used_cells()  
	if cells.is_empty():
		return
	var cell = cells.pick_random()
	food_tiles.set_cell(cell, 0, food_tile)
	print("food spawned at ", cell)
