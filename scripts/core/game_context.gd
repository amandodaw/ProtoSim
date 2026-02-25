class_name GameContext

var registry: EcsRegistry
var game_state
var event_bus
var map_tiles: TileMapLayer
var food_tiles: TileMapLayer
var tree_tiles: TileMapLayer
var ui: CanvasLayer
var cell_to_entity: Dictionary = {}

var plant_system: PlantSystem
var tree_system
var agent_actions: AgentActions
