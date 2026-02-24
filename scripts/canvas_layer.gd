extends CanvasLayer

var ctx: GameContext
var player_id : int = -1
@onready var hunger_label = $HungerLabel
@onready var health_label = $HealthLabel
@onready var food_label = $FoodLabel

func _process(delta):
	if ctx == null or ctx.registry == null or player_id < 0:
		return
	hunger_label.text = "Hunger: " + str(int(ctx.registry.get_component(player_id, HungerComponent).value))
	food_label.text = "Food: " + str(int(ctx.registry.get_component(player_id, InventoryComponent).food))
	health_label.text = "Health: " + str(ctx.registry.get_component(player_id, HealthComponent).health)
