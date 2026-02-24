extends CanvasLayer

var world : World
var player_id : int
@onready var hunger_label = $HungerLabel
@onready var health_label = $HealthLabel
@onready var food_label = $FoodLabel

func _process(delta):
	if player_id==null:
		return
	hunger_label.text = "Hunger: " + str(int(world.get_component(player_id, HungerComponent).value))
	food_label.text = "Food: " + str(int(world.get_component(player_id, InventoryComponent).food))
	health_label.text = "Health: " + str(world.get_component(player_id, HealthComponent).health)
