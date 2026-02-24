extends Node2D
class_name World

var player_scene : PackedScene = load("res://scenes/player.tscn")
@onready var map_tiles = $Tilemaps/GroundLayer
@onready var food_tiles = $Tilemaps/FoodLayer
@onready var ui = $CanvasLayer

var ctx: GameContext
var registry: EcsRegistry
var scheduler: SystemScheduler

var input_system : InputSystem
var spawn_system : SpawnSystem
var perception_system : PerceptionSystem
var goap_planner_system : GoapPlannerSystem
var goap_execution_system : GoapExecutionSystem
var world_state_system : WorldStateSystem
var hunger_system : HungerSystem
var plant_system : PlantSystem
var action_system : ActionSystem
var physics_system : PhysicsSystem

func _ready() -> void:
	registry = EcsRegistry.new()
	ctx = GameContext.new()
	scheduler = SystemScheduler.new()
	ctx.registry = registry
	ctx.map_tiles = map_tiles
	ctx.food_tiles = food_tiles
	ctx.ui = ui
	ctx.agent_actions = AgentActions.new()

	input_system = InputSystem.new()
	spawn_system = SpawnSystem.new()
	perception_system = PerceptionSystem.new()
	world_state_system = WorldStateSystem.new()
	goap_planner_system = GoapPlannerSystem.new()
	goap_execution_system = GoapExecutionSystem.new()
	hunger_system = HungerSystem.new()
	plant_system = PlantSystem.new()
	action_system = ActionSystem.new()
	physics_system = PhysicsSystem.new()
	ctx.plant_system = plant_system

	ui.ctx = ctx

	scheduler.register_system(input_system)
	scheduler.register_system(spawn_system)
	scheduler.register_system(world_state_system)
	scheduler.register_system(goap_planner_system)
	scheduler.register_system(goap_execution_system)
	scheduler.register_system(perception_system)
	scheduler.register_system(hunger_system)
	scheduler.register_system(plant_system)
	scheduler.register_system(action_system)
	scheduler.register_system(physics_system)

	create_player()
	create_npc()

func _physics_process(delta: float) -> void:
	scheduler.tick(ctx, delta)

var player 

func create_player():
	var player_id = registry.create_entity()
	ui.player_id = player_id
	var player_pos = PositionComponent.new()
	player_pos.value = get_viewport_rect().size / 2
	registry.add(player_id, player_pos)
	registry.add(player_id, HealthComponent.new())
	registry.add(player_id, HungerComponent.new())
	registry.add(player_id, InventoryComponent.new())
	registry.add(player_id, MovementComponent.new())
	registry.add(player_id, InputComponent.new())
	registry.add(player_id, IntentComponent.new())
	registry.add(player_id, PerceptionComponent.new())
	registry.add(player_id, VisiblePlantsComponent.new())
	player = player_scene.instantiate()
	var body_comp = CharacterBodyComponent.new()
	body_comp.body = player
	player.position = player_pos.value
	registry.add(player_id, body_comp)
	add_child(player)

func create_npc():
	var npc_id = registry.create_entity()

	var pos = PositionComponent.new()
	pos.value = Vector2(300, 300)
	registry.add(npc_id, pos)

	registry.add(npc_id, MovementComponent.new())
	registry.add(npc_id, IntentComponent.new())
	registry.add(npc_id, AgentWorldStateComponent.new())
	registry.add(npc_id, InventoryComponent.new())
	registry.add(npc_id, PerceptionComponent.new())
	registry.add(npc_id, VisiblePlantsComponent.new())
	registry.add(npc_id, GoapPlanComponent.new())
	registry.add(npc_id, HungerComponent.new())
	registry.add(npc_id, HealthComponent.new())

	var npc_node = player_scene.instantiate()
	var body = CharacterBodyComponent.new()
	body.body = npc_node
	npc_node.position = pos.value
	registry.add(npc_id, body)

	add_child(npc_node)
